---
name: wechat-fast-file-send
description: Fast, verified Windows WeChat local-file sending using an existing logged-in main chat window, dynamic contact selection, clipboard file-drop input, approximate-name resolution, and screenshot verification. Use only for explicit requests to send local files or images through WeChat.
---

# 微信文件快速发送

Use the bundled PowerShell scripts only for an explicit user request to send a local file through the Windows WeChat desktop client. Keep every contact, group name, file description, and file path dynamic; never hard-code them.

## Safe workflow

1. Require the existing WeChat desktop client to be logged in with its main chat window open. The script only attaches to that window; it never starts, reopens, or logs into WeChat.
2. Resolve the requested file. For an exact path, verify it exists and is a regular readable file. For an approximate image name, rank candidates without sending:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\wechat-fast-file-send\scripts\resolve-wechat-file.ps1" -Query "<用户描述>" -SearchRoot "<用户指定目录>"
   ```

   The resolver searches only the specified directory by default. Use `-Recurse` only when the user has explicitly included subfolders. Send only an `AUTO_SEND_ELIGIBLE` result. For `REVIEW_REQUIRED`, inspect the leading candidate and ask if ambiguity remains.

3. Verify the intended recipient without staging an attachment:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\wechat-fast-file-send\scripts\send-wechat-file.ps1" -Contact "<联系人或群名>" -VerifyContactOnly
   ```

   Inspect the returned screenshot and continue only if its visible chat title matches exactly.

4. Send the resolved local file:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\wechat-fast-file-send\scripts\send-wechat-file.ps1" -Contact "<联系人或群名>" -FilePath "<绝对文件路径>"
   ```

5. Inspect the final screenshot. `SUBMITTED` means the Enter key was issued; delivery is confirmed only when the screenshot visibly shows the exact recipient and attachment.

## Reliability rules

- The script selects the largest responsive existing `Weixin` main window. A loading, tray-only, or too-small window is rejected; it is never fixed by starting a second client.
- Re-read the WeChat window rectangle immediately before every click; do not reuse old global coordinates.
- Clipboard file-drop input is used for speed. The script captures the staged attachment card before it presses Enter.
- `-DryRun` stages an attachment only for testing, captures it, then uses `Ctrl+Z` to undo the paste. It never sends and never uses `Esc`, which can disturb the existing WeChat session.
- When `winapp` is installed, Windows Graphics Capture produces readable composited screenshots (`CaptureMode: WGC`); otherwise the script falls back to GDI.
- Do not retry automatically if recipient, filename, upload state, or final screenshot is ambiguous, because a retry can create duplicate files.

## Output

`-VerifyContactOnly` returns `CONTACT_SELECTED`, `Contact`, `ScreenshotPath`, `CaptureMode`, and `WindowRect` without touching an attachment. A normal file run returns `SUBMITTED`, `DeliveryVerification`, `Contact`, `FilePath`, `PreparedScreenshotPath`, `ScreenshotPath`, `CaptureMode`, and `WindowRect`.

