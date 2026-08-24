param(
    [Parameter(Mandatory = $true)]
    [string]$Contact,

    [Parameter(Mandatory = $true)]
    [string]$Message,

    [string]$ScreenshotPath,

    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$drawingAssembly = [System.Drawing.Bitmap].Assembly.Location
Add-Type -ReferencedAssemblies $drawingAssembly @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class WechatFastNative {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, IntPtr processId);
    [DllImport("kernel32.dll")] public static extern uint GetCurrentThreadId();
    [DllImport("user32.dll")] public static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool attach);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int command);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
    [DllImport("user32.dll")] public static extern void mouse_event(uint flags, uint dx, uint dy, uint data, UIntPtr extra);
    [DllImport("user32.dll")] public static extern void keybd_event(byte key, byte scan, uint flags, UIntPtr extra);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }

    public const uint MouseLeftDown = 0x0002;
    public const uint MouseLeftUp = 0x0004;
    public const uint KeyUp = 0x0002;

    public static void Click(int x, int y) {
        SetCursorPos(x, y);
        mouse_event(MouseLeftDown, 0, 0, 0, UIntPtr.Zero);
        mouse_event(MouseLeftUp, 0, 0, 0, UIntPtr.Zero);
    }

    public static void Key(byte key) {
        keybd_event(key, 0, 0, UIntPtr.Zero);
        keybd_event(key, 0, KeyUp, UIntPtr.Zero);
    }

    public static void Chord(byte modifier, byte key) {
        keybd_event(modifier, 0, 0, UIntPtr.Zero);
        keybd_event(key, 0, 0, UIntPtr.Zero);
        keybd_event(key, 0, KeyUp, UIntPtr.Zero);
        keybd_event(modifier, 0, KeyUp, UIntPtr.Zero);
    }

    public static void Focus(IntPtr target) {
        IntPtr foreground = GetForegroundWindow();
        uint foregroundThread = GetWindowThreadProcessId(foreground, IntPtr.Zero);
        uint targetThread = GetWindowThreadProcessId(target, IntPtr.Zero);
        uint currentThread = GetCurrentThreadId();
        AttachThreadInput(currentThread, foregroundThread, true);
        AttachThreadInput(currentThread, targetThread, true);
        ShowWindow(target, 9);
        SetForegroundWindow(target);
        AttachThreadInput(currentThread, targetThread, false);
        AttachThreadInput(currentThread, foregroundThread, false);
    }

    public static void Capture(IntPtr target, string path) {
        RECT rect;
        if (!GetWindowRect(target, out rect)) throw new InvalidOperationException("Cannot read WeChat window rectangle");
        int width = rect.Right - rect.Left;
        int height = rect.Bottom - rect.Top;
        using (var bitmap = new Bitmap(width, height))
        using (var graphics = Graphics.FromImage(bitmap)) {
            graphics.CopyFromScreen(rect.Left, rect.Top, 0, 0, bitmap.Size);
            bitmap.Save(path, ImageFormat.Png);
        }
    }
}
'@

function Set-ReliableClipboard([string]$Text) {
    for ($attempt = 1; $attempt -le 5; $attempt++) {
        try {
            Set-Clipboard -Value $Text
            Start-Sleep -Milliseconds 120
            return
        } catch {
        }
        Start-Sleep -Milliseconds 300
    }
    throw 'Cannot write to the Windows clipboard reliably'
}

function Get-VisibleWechatWindows() {
    Get-Process -Name Weixin -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 -and $_.Responding } |
        ForEach-Object {
            $rect = New-Object WechatFastNative+RECT
            if ([WechatFastNative]::GetWindowRect([IntPtr]$_.MainWindowHandle, [ref]$rect)) {
                $width = $rect.Right - $rect.Left
                $height = $rect.Bottom - $rect.Top
                if ($width -gt 0 -and $height -gt 0) {
                    [pscustomobject]@{
                        Process = $_
                        Width = $width
                        Height = $height
                        Area = $width * $height
                    }
                }
            }
        }
}

function Get-RunningWechatProcess() {
    $mainWindow = @(Get-VisibleWechatWindows |
        Where-Object { $_.Width -ge 600 -and $_.Height -ge 500 } |
        Sort-Object -Property Area -Descending |
        Select-Object -First 1)
    if ($mainWindow) { return $mainWindow[0].Process }
}

function Get-WechatWindow() {
    $process = Get-RunningWechatProcess
    if ($process) { return [IntPtr]$process.MainWindowHandle }

    $visibleWindows = @(Get-VisibleWechatWindows)
    if ($visibleWindows.Count -gt 0) {
        $largest = $visibleWindows | Sort-Object -Property Area -Descending | Select-Object -First 1
        throw "WeChat is open but its main chat window is not ready ($($largest.Width)x$($largest.Height)); restore the existing logged-in chat window and retry"
    }
    throw 'No existing logged-in WeChat main chat window was found. This skill never starts or reopens WeChat automatically.'
}

function Get-WindowRect([IntPtr]$Window) {
    $rect = New-Object WechatFastNative+RECT
    if (-not [WechatFastNative]::GetWindowRect($Window, [ref]$rect)) { throw 'Cannot read WeChat window rectangle' }
    return $rect
}

function Capture-WechatWindow([IntPtr]$Window, [string]$Path) {
    $winapp = Get-Command winapp -ErrorAction SilentlyContinue
    if ($winapp) {
        try {
            & $winapp.Source ui screenshot -w ([Int64]$Window) --focus --output $Path --json 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath $Path -PathType Leaf)) {
                return 'WGC'
            }
        } catch {
        }
    }

    [WechatFastNative]::Capture($Window, $Path)
    return 'GDI'
}

$window = Get-WechatWindow
[WechatFastNative]::Focus($window)
Start-Sleep -Milliseconds 250

[WechatFastNative]::Chord(0x11, 0x46)
Start-Sleep -Milliseconds 200
Set-ReliableClipboard $Contact
[WechatFastNative]::Chord(0x11, 0x56)
Start-Sleep -Milliseconds 450
[WechatFastNative]::Key(0x0D)
Start-Sleep -Milliseconds 650

[WechatFastNative]::Focus($window)
$rect = Get-WindowRect $window
$width = $rect.Right - $rect.Left
$height = $rect.Bottom - $rect.Top
$inputX = $rect.Left + [int]($width * 0.65)
$inputY = $rect.Top + $height - [int]($height * 0.12)
[WechatFastNative]::Click($inputX, $inputY)
Start-Sleep -Milliseconds 200
[WechatFastNative]::Chord(0x11, 0x41)
[WechatFastNative]::Key(0x08)
Set-ReliableClipboard $Message
[WechatFastNative]::Chord(0x11, 0x56)
Start-Sleep -Milliseconds 220
[WechatFastNative]::Focus($window)

if ($DryRun) {
    if ([string]::IsNullOrWhiteSpace($ScreenshotPath)) {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $ScreenshotPath = Join-Path ([IO.Path]::GetTempPath()) "wechat-fast-send-dry-run-$stamp.png"
    }
    $captureMode = Capture-WechatWindow $window $ScreenshotPath
    [WechatFastNative]::Chord(0x11, 0x41)
    [WechatFastNative]::Key(0x08)
    [pscustomobject]@{
        Status = 'DRY_RUN'
        Contact = $Contact
        Message = $Message
        ScreenshotPath = $ScreenshotPath
        CaptureMode = $captureMode
        WindowRect = "$($rect.Left),$($rect.Top),$($rect.Right),$($rect.Bottom)"
    } | ConvertTo-Json -Compress
    return
}

[WechatFastNative]::Key(0x0D)
Start-Sleep -Milliseconds 700

if ([string]::IsNullOrWhiteSpace($ScreenshotPath)) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $ScreenshotPath = Join-Path ([IO.Path]::GetTempPath()) "wechat-fast-send-$stamp.png"
}
$captureMode = Capture-WechatWindow $window $ScreenshotPath

[pscustomobject]@{
    Status = 'SENT'
    Contact = $Contact
    Message = $Message
    ScreenshotPath = $ScreenshotPath
    CaptureMode = $captureMode
    WindowRect = "$($rect.Left),$($rect.Top),$($rect.Right),$($rect.Bottom)"
} | ConvertTo-Json -Compress

