param(
    [Parameter(Mandatory = $true)]
    [string]$Contact,

    [string]$FilePath,

    [string]$ScreenshotPath,

    [ValidateRange(250, 10000)]
    [int]$AttachmentWaitMs = 900,

    [ValidateRange(250, 30000)]
    [int]$PostSendWaitMs = 1200,

    [switch]$DryRun,

    [switch]$VerifyContactOnly
)

$ErrorActionPreference = 'Stop'

$resolvedFile = $null
if (-not $VerifyContactOnly) {
    if ([string]::IsNullOrWhiteSpace($FilePath)) {
        throw 'FilePath is required unless -VerifyContactOnly is used'
    }
    $resolvedFile = (Resolve-Path -LiteralPath $FilePath).Path
    if (-not (Test-Path -LiteralPath $resolvedFile -PathType Leaf)) {
        throw "Attachment file was not found: $FilePath"
    }
}

Add-Type -AssemblyName System.Drawing

$drawingAssembly = [System.Drawing.Bitmap].Assembly.Location
Add-Type -ReferencedAssemblies $drawingAssembly @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class WechatFastFileNative {
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

function Set-ReliableTextClipboard([string]$Text) {
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

function Set-ReliableFileClipboard([string]$Path) {
    for ($attempt = 1; $attempt -le 5; $attempt++) {
        try {
            Set-Clipboard -Path $Path
            Start-Sleep -Milliseconds 250
            $items = @(Get-Clipboard -Format FileDropList -ErrorAction Stop)
            if ($items.Count -eq 1) {
                $clipboardPath = (Resolve-Path -LiteralPath ([string]$items[0])).Path
                if ($clipboardPath -eq $resolvedFile) { return }
            }
        } catch {
        }
        Start-Sleep -Milliseconds 300
    }
    throw 'Cannot write the attachment to the Windows clipboard reliably'
}

function Get-VisibleWechatWindows() {
    Get-Process -Name Weixin -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 -and $_.Responding } |
        ForEach-Object {
            $rect = New-Object WechatFastFileNative+RECT
            if ([WechatFastFileNative]::GetWindowRect([IntPtr]$_.MainWindowHandle, [ref]$rect)) {
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

    if (-not $process) {
        $visibleWindows = @(Get-VisibleWechatWindows)
        if ($visibleWindows.Count -gt 0) {
            $largest = $visibleWindows | Sort-Object -Property Area -Descending | Select-Object -First 1
            throw "WeChat is open but its main chat window is not ready ($($largest.Width)x$($largest.Height)); wait for the fully loaded chat window before retrying"
        }
        throw 'No existing logged-in WeChat main chat window was found. This skill never starts or reopens WeChat automatically.'
    }
    return [IntPtr]$process.MainWindowHandle
}

function Get-WindowRect([IntPtr]$Window) {
    $rect = New-Object WechatFastFileNative+RECT
    if (-not [WechatFastFileNative]::GetWindowRect($Window, [ref]$rect)) { throw 'Cannot read WeChat window rectangle' }
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

    [WechatFastFileNative]::Capture($Window, $Path)
    return 'GDI'
}

$window = Get-WechatWindow
[WechatFastFileNative]::Focus($window)
Start-Sleep -Milliseconds 250

[WechatFastFileNative]::Chord(0x11, 0x46)
Start-Sleep -Milliseconds 200
Set-ReliableTextClipboard $Contact
[WechatFastFileNative]::Chord(0x11, 0x56)
Start-Sleep -Milliseconds 450
[WechatFastFileNative]::Key(0x0D)
Start-Sleep -Milliseconds 650

[WechatFastFileNative]::Focus($window)
$rect = Get-WindowRect $window
$width = $rect.Right - $rect.Left
$height = $rect.Bottom - $rect.Top

if ($VerifyContactOnly) {
    if ([string]::IsNullOrWhiteSpace($ScreenshotPath)) {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $ScreenshotPath = Join-Path ([IO.Path]::GetTempPath()) "wechat-fast-file-contact-verified-$stamp.png"
    }
    $captureMode = Capture-WechatWindow $window $ScreenshotPath
    [pscustomobject]@{
        Status = 'CONTACT_SELECTED'
        Contact = $Contact
        ScreenshotPath = $ScreenshotPath
        CaptureMode = $captureMode
        WindowRect = "$($rect.Left),$($rect.Top),$($rect.Right),$($rect.Bottom)"
    } | ConvertTo-Json -Compress
    return
}

$inputX = $rect.Left + [int]($width * 0.65)
$inputY = $rect.Top + $height - [int]($height * 0.12)
[WechatFastFileNative]::Click($inputX, $inputY)
Start-Sleep -Milliseconds 200
Set-ReliableFileClipboard $resolvedFile
[WechatFastFileNative]::Chord(0x11, 0x56)
Start-Sleep -Milliseconds $AttachmentWaitMs
[WechatFastFileNative]::Focus($window)

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$preparedScreenshotPath = Join-Path ([IO.Path]::GetTempPath()) "wechat-fast-file-prepared-$stamp.png"
if ([string]::IsNullOrWhiteSpace($ScreenshotPath)) {
    $ScreenshotPath = Join-Path ([IO.Path]::GetTempPath()) "wechat-fast-file-$stamp.png"
}
$preparedCaptureMode = Capture-WechatWindow $window $preparedScreenshotPath

if ($DryRun) {
    [WechatFastFileNative]::Chord(0x11, 0x5A)
    Start-Sleep -Milliseconds 150
    [WechatFastFileNative]::Focus($window)
    [pscustomobject]@{
        Status = 'DRY_RUN'
        Contact = $Contact
        FilePath = $resolvedFile
        PreparedScreenshotPath = $preparedScreenshotPath
        ScreenshotPath = $preparedScreenshotPath
        CaptureMode = $preparedCaptureMode
        CleanupAction = 'UNDO_PASTE'
        WindowRect = "$($rect.Left),$($rect.Top),$($rect.Right),$($rect.Bottom)"
    } | ConvertTo-Json -Compress
    return
}

[WechatFastFileNative]::Key(0x0D)
Start-Sleep -Milliseconds $PostSendWaitMs
$finalCaptureMode = Capture-WechatWindow $window $ScreenshotPath

[pscustomobject]@{
    Status = 'SUBMITTED'
    DeliveryVerification = 'VISUAL_CHECK_REQUIRED'
    Contact = $Contact
    FilePath = $resolvedFile
    PreparedScreenshotPath = $preparedScreenshotPath
    ScreenshotPath = $ScreenshotPath
    CaptureMode = $finalCaptureMode
    WindowRect = "$($rect.Left),$($rect.Top),$($rect.Right),$($rect.Bottom)"
} | ConvertTo-Json -Compress

