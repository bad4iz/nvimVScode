--[[
CONSOLELOG.NVIM — результаты выполнения рядом с кодом
https://github.com/chriswritescode-dev/consolelog.nvim

Что умеет и чем удобен:
  • Показывает console.log/error/warn/info/debug прямо у строки вызова:
    меньше переключений между редактором, терминалом и DevTools.
  • Небольшие объекты видны inline, большие можно открыть в инспекторе
    и скопировать; сохраняется история нескольких выводов одной строки.
  • Общий инспектор собирает вывод разных буферов; Enter ведёт к исходнику,
    q / Esc закрывают окно. Есть отдельный просмотр текущего буфера.
  • Браузерный захват: React, Next.js, Vue, Vite и другие проекты с source maps.
    Точное сопоставление вывода с исходником зависит от доступных source maps.
  • Запускает отдельные JS/TS/Python-файлы и перезапускает их при сохранении
    после первого ручного запуска. Есть управление несколькими сессиями.
  • Python: print(), logging, stderr и необработанные исключения.
  • Дополнительно умеет объяснять код построчно через LLM (по команде).

Как пользоваться (leader = Space):
  <Space>Lt  / :ConsoleLogToggle         — включить / выключить захват
  <Space>Lr  / :ConsoleLogRun            — выполнить сохранённый файл
  <Space>Lx  / :ConsoleLogClear          — очистить вывод
  <Space>Li  / :ConsoleLogInspect        — значение на строке курсора
  <Space>La  / :ConsoleLogInspectAll     — вывод всех буферов
  <Space>Lb  / :ConsoleLogInspectBuffer  — вывод текущего буфера
  <Space>Ls  / :ConsoleLogStatus         — состояние и диагностика
  <Space>Ld  / :ConsoleLogDebugToggle    — включить / выключить отладочный лог
  :ConsoleLogDebug / :ConsoleLogDebugClear — открыть / очистить отладочный лог
  :ConsoleLogReload                     — перезагрузить плагин
  :ConsoleLogExplain                    — объяснить буфер или выделенный диапазон
  :ConsoleLogExplainClear               — очистить пояснения
  :ConsoleLogExplainToggle              — скрыть / показать пояснения
  :ConsoleLogExplainInspect             — открыть пояснение строки
  :ConsoleLogExplainStop                — прервать запрос к LLM

Быстрый старт:
  JS/Python: сохрани файл с console.log(...) / print(...), нажми <Space>Lr.
  Браузер: открой JS/TS-файл проекта — захват включится автоматически. Запусти
  dev-сервер (например, npm run dev), открой приложение в браузере и вызови лог.
  Если вывода нет — проверь :ConsoleLogStatus и source maps.

Требования и ограничения:
  • JS: Node.js; расширения .js/.mjs/.cjs. TS: .ts/.mts/.cts, Node >= 22.6;
    до 23.6 плагин добавляет --experimental-strip-types. Это удаление типов,
    а не полноценная сборка: преобразования tsconfig и конструкции, требующие
    генерации JS (например, enum), не поддерживаются. JSX/TSX — через dev-сервер.
  • Python >= 3.8, без внешних пакетов. Интерпретатор: настройка
    runner.python_executable → VIRTUAL_ENV → ближайшая .venv/venv → python3.
  • Захват включается автоматически для поддерживаемых буферов; браузерный
    захват внедряет клиент в проект. Используй только для локальной разработки
    и проверяй git diff проекта. <Space>Lt отключает захват.
  • После :ConsoleLogRun сохранение повторно ВЫПОЛНЯЕТ скрипт, включая его
    побочные эффекты; отключи runner.rerun_on_save, если это нежелательно.
  • Explain требует curl и OPENAI_API_KEY (по умолчанию) либо настройки другого
    провайдера. Команда отправляет код и контекст файла во внешний API:
    не вызывай её для секретов/закрытого кода без разрешения. Для логов LLM не нужен.

Клавиши плагина по умолчанию (<leader>l...) отключены, чтобы без кипиша
сохранить штатную LSP-группу AstroNvim. Наши клавиши регистрирует Lazy.
--]]

---@type LazySpec
return {
  "chriswritescode-dev/consolelog.nvim",
  ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "python" },
  cmd = {
    "ConsoleLogToggle",
    "ConsoleLogRun",
    "ConsoleLogClear",
    "ConsoleLogInspect",
    "ConsoleLogInspectAll",
    "ConsoleLogInspectBuffer",
    "ConsoleLogStatus",
    "ConsoleLogDebugToggle",
    "ConsoleLogDebug",
    "ConsoleLogDebugClear",
    "ConsoleLogReload",
    "ConsoleLogExplain",
    "ConsoleLogExplainClear",
    "ConsoleLogExplainToggle",
    "ConsoleLogExplainInspect",
    "ConsoleLogExplainStop",
  },
  opts = {
    auto_enable = true,
    log_level = "warn",
    keymaps = { enabled = false },
    display = { max_width = 100 },
    websocket = { display_methods = { "log", "error", "warn", "info", "debug" } },
    runner = { rerun_on_save = true },
  },
  keys = {
    { "<leader>Lt", "<cmd>ConsoleLogToggle<cr>", desc = "ConsoleLog: включить / выключить" },
    { "<leader>Lr", "<cmd>ConsoleLogRun<cr>", desc = "ConsoleLog: выполнить файл" },
    { "<leader>Lx", "<cmd>ConsoleLogClear<cr>", desc = "ConsoleLog: очистить вывод" },
    { "<leader>Li", "<cmd>ConsoleLogInspect<cr>", desc = "ConsoleLog: значение под курсором" },
    { "<leader>La", "<cmd>ConsoleLogInspectAll<cr>", desc = "ConsoleLog: весь вывод" },
    { "<leader>Lb", "<cmd>ConsoleLogInspectBuffer<cr>", desc = "ConsoleLog: вывод буфера" },
    { "<leader>Ls", "<cmd>ConsoleLogStatus<cr>", desc = "ConsoleLog: состояние" },
    { "<leader>Ld", "<cmd>ConsoleLogDebugToggle<cr>", desc = "ConsoleLog: отладочный лог" },
  },
}
