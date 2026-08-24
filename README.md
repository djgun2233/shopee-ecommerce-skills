# Shopee E-commerce & WeChat Skills

通用 Shopee 商品图片、泰国站电商文案与 Windows 微信发送技能包。

This repository contains reusable Codex skills for product-agnostic Shopee
workflows:

- `shopee-product-imagegen`: evidence-based product-image prompts, realistic
  scenes, localized image text, comparison layouts, prompt manifests, and
  delivery validation. See `references/` for reusable style and prompt
  templates.
- `product-title-optimization`: marketplace-aware titles with Thai
  localization, keyword structure, parameter checks, and claim auditing.
- `product-description-generator`: Thai listing highlights and detail pages
  grounded in confirmed product facts. See `references/` for the reusable
  Thai Shopee listing template.
- `wechat-fast-send`: verified Windows WeChat text sending through an existing
  logged-in desktop window, with dynamic recipient input and screenshot checks.
- `wechat-fast-file-send`: verified Windows WeChat local-file sending through
  clipboard file-drop input, dynamic file resolution and screenshot checks.

## Repository description

Reusable Shopee image-generation, Thai listing, and verified Windows WeChat
delivery skills with dynamic inputs, evidence-based checks, and no embedded
personal data.

## Design principles

1. Derive product facts from the current references and specifications.
2. Keep confirmed, unknown, and forbidden claims separate.
3. Prepare and review a prompt manifest before generating image batches.
4. Use resolved, physically plausible scenes and buyer-readable layouts.
5. Review full-size and thumbnail outputs before delivery.
6. Use the target marketplace language for publishable copy, with Chinese
   translation kept separate for review.
7. Keep messaging recipients, groups, file paths and message contents dynamic;
   never embed personal recipients or machine-specific paths in a skill.

The image workflow uses the host's built-in image-generation capability unless
the user explicitly requests an API. It does not require API keys.

## Installation

Copy the skill folders under the Codex skills directory, preserving each
folder's `SKILL.md`, `agents/`, and `references/` files. The exact destination
depends on the Codex installation.

## Privacy and scope

This repository is intentionally product-agnostic. It contains no product
photos, order data, private prompts, local machine paths, credentials, API
keys, WeChat IDs, contact names, message history, or project-specific output
files.

## License

Add the license that matches your intended reuse and distribution terms before
publishing a public fork.

