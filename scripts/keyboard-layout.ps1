$ErrorActionPreference = 'Stop'

# A numeric request ID returns ID|LANGID|isWindowsTerminal; EOF stops the helper.
# Query the focused control's thread because Terminal can host it on a child HWND.
$nativeSource = @'
using System;
using System.Diagnostics;
using System.Globalization;
using System.Runtime.InteropServices;

public static class TerminalKeyboardLayout
{
    [StructLayout(LayoutKind.Sequential)]
    private struct Rect { public int Left, Top, Right, Bottom; }

    [StructLayout(LayoutKind.Sequential)]
    private struct GuiThreadInfo
    {
        public uint Size, Flags;
        public IntPtr Active, Focus, Capture, MenuOwner, MoveSize, Caret;
        public Rect CaretRect;
    }

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    private static extern uint GetWindowThreadProcessId(IntPtr window, out uint processId);

    [DllImport("user32.dll")]
    private static extern IntPtr GetKeyboardLayout(uint threadId);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool GetGUIThreadInfo(uint threadId, ref GuiThreadInfo info);

    public static string Read()
    {
        IntPtr window = GetForegroundWindow();
        if (window == IntPtr.Zero) return "0000|0";
        uint processId;
        uint threadId = GetWindowThreadProcessId(window, out processId);
        if (threadId == 0 || processId == 0) return "0000|0";

        bool terminal;
        try
        {
            using (Process process = Process.GetProcessById((int)processId))
                terminal = String.Equals(process.ProcessName, "WindowsTerminal", StringComparison.OrdinalIgnoreCase);
        }
        catch (ArgumentException) { return "0000|0"; }
        catch (System.ComponentModel.Win32Exception) { return "0000|0"; }

        GuiThreadInfo info = new GuiThreadInfo();
        info.Size = (uint)Marshal.SizeOf(typeof(GuiThreadInfo));
        if (GetGUIThreadInfo(threadId, ref info) && info.Focus != IntPtr.Zero)
        {
            uint focusedProcessId;
            uint focusedThreadId = GetWindowThreadProcessId(info.Focus, out focusedProcessId);
            if (focusedThreadId != 0 && focusedProcessId == processId) threadId = focusedThreadId;
        }

        long layout = GetKeyboardLayout(threadId).ToInt64();
        if (window != GetForegroundWindow()) return "0000|0";
        return (layout & 0xffff).ToString("X4", CultureInfo.InvariantCulture) + (terminal ? "|1" : "|0");
    }
}
'@

try {
    Add-Type -TypeDefinition $nativeSource
    [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
    while ($null -ne ($requestId = [Console]::ReadLine())) {
        if ($requestId -notmatch '^[0-9]+$') { continue }
        [Console]::WriteLine($requestId + '|' + [TerminalKeyboardLayout]::Read())
        [Console]::Out.Flush()
    }
}
catch {
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
