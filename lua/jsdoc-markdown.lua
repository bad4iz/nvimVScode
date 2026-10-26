local M = {}
local api = vim.api
local namespace = api.nvim_create_namespace "jsdoc_markdown"
local languages =
  { javascript = "javascript", javascriptreact = "javascript", typescript = "typescript", typescriptreact = "tsx" }
local pending = {}
local queries = {}
local window_options = {}

local function configure_windows()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    if languages[vim.bo[buf].filetype] then
      if not window_options[win] then window_options[win] = { vim.wo[win].conceallevel, vim.wo[win].concealcursor } end
      vim.wo[win].conceallevel = 2
      vim.wo[win].concealcursor = ""
    elseif window_options[win] then
      vim.wo[win].conceallevel = window_options[win][1]
      vim.wo[win].concealcursor = window_options[win][2]
      window_options[win] = nil
    end
  end
  for win in pairs(window_options) do
    if not api.nvim_win_is_valid(win) then window_options[win] = nil end
  end
end

local function colors()
  api.nvim_set_hl(0, "JSDocMarkdownBody", { fg = "#819783", italic = true })
  api.nvim_set_hl(0, "JSDocMarkdownTitle", { fg = "#b5a17e", italic = true, bold = true })
  api.nvim_set_hl(0, "JSDocMarkdownH1", { fg = "#c6b28e", bg = "#2b2930", bold = true, italic = false, nocombine = true })
  api.nvim_set_hl(0, "JSDocMarkdownH2", { fg = "#8fa9bd", bold = true, italic = false })
  api.nvim_set_hl(0, "JSDocMarkdownH3", { fg = "#a397ad", bold = false, italic = true })
  api.nvim_set_hl(0, "JSDocMarkdownH4", { fg = "#8fa9bd", italic = false, bold = false })
  api.nvim_set_hl(0, "JSDocMarkdownH5", { fg = "#a49ab0", italic = true, bold = false })
  api.nvim_set_hl(0, "JSDocMarkdownH6", { fg = "#9199a6", italic = true, bold = false })
  api.nvim_set_hl(0, "JSDocMarkdownMarker", { fg = "#50596d" })
  api.nvim_set_hl(0, "JSDocMarkdownCode", { fg = "#8fa9bd", bg = "#252936", italic = false })
end

local function mark(buf, row, first, last, group, priority, conceal)
  if last <= first then return end
  api.nvim_buf_set_extmark(buf, namespace, row, first, {
    end_col = last,
    hl_group = "JSDocMarkdown" .. group,
    priority = priority + 100,
    conceal = conceal and "" or nil,
  })
end

-- Remove only the JSDoc margin, retaining byte offsets (including UTF-8 text).
-- Tag lines stay blank in the Markdown copy so native JSDoc captures win there.
local function clean_comment(buf, node)
  local sr, sc, er, ec = node:range()
  local lines = api.nvim_buf_get_lines(buf, sr, er + 1, false)
  local cleaned, mapping = {}, {}
  local summary_seen = false
  for index, line in ipairs(lines) do
    local first = index == 1 and sc + 3 or 0
    local last = index == #lines and ec - 2 or #line
    if index > 1 then
      local margin = line:match "^%s*%* ?"
      if margin then first = math.min(#margin, last) end
    end
    last = math.max(first, last)
    local text = line:sub(first + 1, last)
    local tag = text:match "^%s*@"
    mapping[index] = { row = sr + index - 1, col = first, length = #text, tag = tag }
    cleaned[index] = tag and "" or text
    mark(buf, sr + index - 1, index == 1 and sc or 0, first, "Marker", 140)
    if index == #lines then mark(buf, er, last, ec, "Marker", 140) end
    if not tag then mark(buf, sr + index - 1, first, last, "Body", 110) end
    -- The first nonempty prose line is the JSDoc summary/title, in any language.
    if not summary_seen and text:match "%S" then
      summary_seen = true
      if not tag then mark(buf, sr + index - 1, first, last, "Title", 120) end
    end
  end
  return table.concat(cleaned, "\n"), mapping
end

local function mark_node(buf, node, mapping, group, priority)
  local sr, sc, er, ec = node:range()
  for row = sr, er do
    local line = mapping[row + 1]
    if line and not line.tag then
      local first = row == sr and sc or 0
      local last = row == er and ec or line.length
      mark(buf, line.row, line.col + first, line.col + math.min(last, line.length), group, priority, group == "Marker")
    end
  end
end

local function indent_heading(buf, node, mapping, level)
  if level == 1 then return end
  local content = node:field("heading_content")[1]
  if not content then return end
  local sr, sc, er, ec = content:range()
  -- Use content ranges so setext underlines and ATX markers keep their positions.
  for row = sr, er do
    local line = mapping[row + 1]
    local first = row == sr and sc or 0
    local last = row == er and ec or (line and line.length or 0)
    if line and not line.tag and last > first then
      api.nvim_buf_set_extmark(buf, namespace, line.row, line.col + first, {
        virt_text = { { string.rep(" ", 2 * (level - 1)), "JSDocMarkdownBody" } },
        virt_text_pos = "inline",
        priority = 225,
        right_gravity = false,
      })
    end
  end
end

local markdown_queries = {
  markdown = [[
    (atx_heading (atx_h1_marker)) @h1
    (atx_heading (atx_h2_marker)) @h2
    (atx_heading (atx_h3_marker)) @h3
    (atx_heading (atx_h4_marker)) @h4
    (atx_heading (atx_h5_marker)) @h5
    (atx_heading (atx_h6_marker)) @h6
    (setext_heading (setext_h1_underline)) @h1
    (setext_heading (setext_h2_underline)) @h2
    [(atx_h1_marker) (atx_h2_marker) (atx_h3_marker)
     (atx_h4_marker) (atx_h5_marker) (atx_h6_marker)
     (setext_h1_underline) (setext_h2_underline)] @marker
    (fenced_code_block) @code
    (fenced_code_block_delimiter) @marker
  ]],
  markdown_inline = [[
    (strong_emphasis) @title
    (code_span) @code
    [(emphasis_delimiter) (code_span_delimiter)] @marker
  ]],
}
local styles = {
  title = { "Title", 120 },
  -- Explicit headings override the summary and strong emphasis, but not inline code.
  h1 = { "H1", 125 },
  h2 = { "H2", 125 },
  h3 = { "H3", 125 },
  h4 = { "H4", 125 },
  h5 = { "H5", 125 },
  h6 = { "H6", 125 },
  code = { "Code", 130 },
  marker = { "Marker", 140 },
}

local function highlight_comment(buf, node)
  local source, mapping = clean_comment(buf, node)
  -- A string parser is necessary: query offsets cannot strip every leading '*'.
  -- Limit injections to inline Markdown; fenced snippets need no extra parsers.
  local parser = vim.treesitter.get_string_parser(source, "markdown", {
    injections = {
      markdown = '((inline) @injection.content (#set! injection.language "markdown_inline"))',
      markdown_inline = "",
    },
  })
  parser:parse(true)
  parser:for_each_tree(function(tree, language_tree)
    local language = language_tree:lang()
    if not markdown_queries[language] then return end
    queries[language] = queries[language] or vim.treesitter.query.parse(language, markdown_queries[language])
    local query = queries[language]
    for id, capture in query:iter_captures(tree:root(), source) do
      local name = query.captures[id]
      local style = styles[name]
      mark_node(buf, capture, mapping, style[1], style[2])
      local level = tonumber(name:match "^h([1-6])$")
      if level then indent_heading(buf, capture, mapping, level) end
    end
  end)
end

function M.refresh(buf)
  if not api.nvim_buf_is_loaded(buf) then return end
  api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
  local language = languages[vim.bo[buf].filetype]
  if not language then return end
  local ok, parser = pcall(vim.treesitter.get_parser, buf, language)
  if not ok then return end
  local markdown_ok = pcall(vim.treesitter.language.add, "markdown")
  local inline_ok = pcall(vim.treesitter.language.add, "markdown_inline")
  if not markdown_ok or not inline_ok then return end
  queries[language] = queries[language] or vim.treesitter.query.parse(language, "(comment) @comment")
  local trees = parser:parse()
  if not trees then return end
  for _, tree in ipairs(trees) do
    for _, node in queries[language]:iter_captures(tree:root(), buf) do
      local text = vim.treesitter.get_node_text(node, buf)
      if text:sub(1, 3) == "/**" and text:sub(-2) == "*/" and #text >= 5 then highlight_comment(buf, node) end
    end
  end
end

local function schedule(buf)
  if pending[buf] then return end
  pending[buf] = true
  vim.defer_fn(function()
    pending[buf] = nil
    M.refresh(buf)
  end, 80)
end

function M.setup()
  colors()
  configure_windows()
  local group = api.nvim_create_augroup("JSDocMarkdown", { clear = true })
  api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
    group = group,
    callback = configure_windows,
  })
  api.nvim_create_autocmd({ "FileType", "BufWinEnter", "TextChanged", "TextChangedI", "TextChangedP" }, {
    group = group,
    callback = function(event) schedule(event.buf) end,
  })
  api.nvim_create_autocmd("ColorScheme", { group = group, callback = colors })
  local namespaces = api.nvim_get_namespaces()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then
      for _, name in ipairs { "practice_header_preview", "practice_jsdoc_title_preview" } do
        if namespaces[name] then api.nvim_buf_clear_namespace(buf, namespaces[name], 0, -1) end
      end
      M.refresh(buf)
    end
  end
end

return M
