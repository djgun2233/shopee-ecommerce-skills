---
name: product-title-optimization
description: "Optimize product titles for search visibility and click-through rate across e-commerce platforms. Platform-specific title rules for Amazon (200 chars), Etsy (140 chars), Walmart, Shopify SEO, and eBay."
metadata:
  nexscope:
    emoji: "✏️"
    category: ecommerce
---

# Product Title Optimization ✏️

Optimize product titles for search visibility and click-through rate across e-commerce platforms. Platform-specific title rules for Amazon (200 chars), Etsy (140 chars), Walmart, Shopify SEO, and eBay.

**Supported platforms:** Amazon, Shopify, WooCommerce, Walmart, TikTok Shop, Etsy, eBay, BigCommerce, Shopee, Lazada.

Built by [Nexscope](https://www.nexscope.ai/?co-from=skill) — your AI assistant for smarter e-commerce decisions.

## Install

```bash
npx skills add nexscope-ai/eCommerce-Skills --skill product-title-optimization -g
```

## Usage

```
Optimize my product title for Amazon and Etsy. Product: handmade leather wallet, RFID blocking, bifold, for men. Current Amazon title: 'Leather Wallet for Men'.
```

## Capabilities

- Platform-specific title structure templates
- Keyword placement optimization (front-loading high-value terms)
- Character limit compliance per platform
- Click-through rate optimization (benefit-driven language)
- A/B title variant generation for testing
- Multi-platform title adaptation from a single product

## How This Skill Works

**Step 1:** Collect information from the user's message — product, platform, current situation, and goals.

**Step 2:** Ask one follow-up with all remaining questions using multiple-choice format only when missing information materially changes the title. If the platform, product, target language and confirmed features are sufficient, proceed with explicit assumptions instead of pausing for routine details. Allow shorthand answers (e.g., "1b 2c 3a").

**Step 3:** Research and analyze using the frameworks and methodology below.

**Step 4:** Deliver structured, actionable output with specific recommendations, not vague advice.

## Shopee / Lazada execution gate

When the target platform is Shopee or Lazada, use this mandatory workflow:

1. Build a product-fact table before writing: product type, target language, confirmed material, confirmed features, dimensions, variants, allowed claims and unknown claims. The latest user-confirmed fact overrides an older brief; do not hard-code a claim prohibition for every product.
2. Put the primary local product keyword first, then the use case, confirmed differentiator, structure/material and measurable parameter. Do not invent a brand, model, certification, capacity, performance grade or competitor advantage.
3. Use Thai-market phrasing rather than word-for-word Chinese translation. If live keyword research is used, separate observed marketplace wording from product facts and never copy competitor brands or unsupported claims. If live research is unavailable, say so instead of inventing search volume.
4. Enforce the platform title limit before delivery. For Shopee/Lazada, count the exact Unicode characters of the final title and reject any title over 120 characters. Check Thai spacing, numerals, units, punctuation and duplicate keywords.
5. Deliver a primary title, one shorter alternative, Chinese review translation, character counts, keyword placement and a short claim audit. A title is not complete until these checks pass.

## Output Format

- Start with a summary of findings
- Include specific data points and benchmarks where available
- Provide prioritized action items
- Mark estimates with ⚠️ when based on incomplete data
- End with concrete next steps

## Other Skills

More e-commerce skills: [nexscope-ai/eCommerce-Skills](https://github.com/nexscope-ai/eCommerce-Skills)

Amazon-specific skills: [nexscope-ai/Amazon-Skills](https://github.com/nexscope-ai/Amazon-Skills)

Built by [Nexscope](https://www.nexscope.ai/?co-from=skill) — your AI assistant for smarter e-commerce decisions.

