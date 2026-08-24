---
name: wechat-fast-send
description: Fast, verified Windows WeChat text messaging using an existing logged-in main chat window, dynamic window-relative input, clipboard retry, safe draft cleanup, and screenshot verification. Use only for explicit requests to send a WeChat message.
---

# 微信文本快速发送

Use `scripts/send-wechat-message.ps1` only for an explicit user request to send a WeChat message. Read the contact or group name and the exact message from the current task. Never hard-code a recipient, group, message, or path.

## Safe workflow

1. Require the existing WeChat desktop client to be logged in with its main chat window open. The script only attaches to that window; it never starts, reopens, or logs into WeChat.
2. Run the script with the exact dynamic contact and message:

   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\wechat-fast-send\scripts\send-wechat-message.ps1" -Contact "<联系人或群名>" -Message "<准确文本>"
   ```

3. Inspect the returned screenshot before reporting success. If the recipient title, message, or window state is unclear, stop rather than resend.

For a non-sending draft check, append `-DryRun`. It captures the draft, then clears only that draft.

## Reliability rules

- Select the largest responsive existing `Weixin` main window. A loading, tray-only, or too-small window is rejected instead of being repaired by launching a second client.
- Re-read the window rectangle immediately before clicking; do not reuse old screen coordinates.
- Clear the chat input before pasting, so a previous draft cannot be mixed into the requested message.
- The script retries clipboard writes to support Chinese text and temporary clipboard contention.
- A `winapp` installation enables Windows Graphics Capture (`CaptureMode: WGC`) for reliable screenshots; otherwise the script falls back to GDI.
- For multiple plausible contact matches, stop and ask for clarification. Do not send to an assumed top result.

## Output

The script returns JSON with `Status`, `Contact`, `Message`, `ScreenshotPath`, `CaptureMode`, and `WindowRect`. `SENT` means the Enter key was issued; only call delivery confirmed after the screenshot visibly shows the intended recipient and message.

