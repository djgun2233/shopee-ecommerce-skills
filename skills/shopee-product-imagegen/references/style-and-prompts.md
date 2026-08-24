# Generic Shopee image blueprint

This reference turns the accepted visual method into reusable prompts for any physical product. Replace bracketed values with facts from the current reference images and specification sheet. Do not carry facts, colors, dimensions, materials or claims from another product into a new job.

## Style-reference transfer

First label each supplied image as a product anchor, structural/evidence reference, or style reference. A style reference supplies only visual decisions: information hierarchy, title-bar shape, supporting-pill treatment, card spacing, color rhythm, macro-inset placement, leader-line geometry, comparison columns, background blur and camera feel. It does not supply product facts. Never import another product's color, material, size, capacity, test result, accessory, food, model, packaging wording or performance claim.

Do not pass a style-only image as the product reference for a different item. Translate the observed style into the prompt and attach only the current product and relevant structural references. If the style reference contains readable text, rewrite every visible string from the current product truth table in the requested marketplace language.

## Product-centered information-image mode

Use this mode when a reference set has a strong Shopee infographic look and the user wants that visual logic applied to a new product. Keep the hierarchy consistent:

1. A large rounded title strip at the top with one exact local-language headline.
2. An optional shorter supporting pill directly below it.
3. A dominant product zone, normally about 55–70% of the meaningful content area.
4. One to three proof elements only: a rounded evidence card, a short leader line with a dot endpoint, one circular or rounded macro inset, or clean double-headed dimension arrows.
5. A real but softly blurred background that provides context without becoming another subject.

The title strip and pill are graphic framing, not a reason to reduce the product. Keep enough negative space around the product for legible Thai text and accurate pointers. Use a dark title strip with a restrained accent pill, white evidence cards, and thin colored outlines only as optional generic treatments; color must not imply an unverified benefit.

For a four-variant hero, show exactly one space per confirmed SKU in a controlled arrangement such as a two-by-two console display. Give every product similar visual access, add exact color labels, and keep people, luggage and decorative props blurred and small. Do not use a busy lifestyle collage for the hero.

For comparison frames, choose the smallest structure that makes ownership unmistakable: full-height left/right zones, two separately bordered photographic cards, a larger foreground card beside a smaller recessed card, or a hero product beside two distinct evidence panels. Separate the sides with borders, gutters, background-color shifts, shadows, headers and a local comparison marker. A continuous center divider is optional. The user's side may be wider and its product larger, but both products and all claims must remain visibly assigned to one side at phone-thumbnail size. Keep the comparison limited to visible, confirmed structure; do not turn layout differences into performance tests or universal superiority.

Do not use every available module in one image. A lifestyle frame can remain a single full-frame scene; a dimension frame can use arrows without a collage; a material frame can use one macro inset without extra comparison panels. The style is a hierarchy, not a requirement to add more objects.

## Common product-anchor block

Attach the exact product reference image(s), then include a block like this in every generation prompt:

> Use the attached product as the exact visual anchor. Preserve its physical design and proportions without redesign: silhouette, scale, surfaces, colors, printed artwork, closures, moving parts, accessories and all visible geometry. Do not add or remove handles, buttons, seals, straps or components. Do not borrow artwork or colors from another variant. Produce photorealistic Shopee ecommerce photography, [USER-SPECIFIED RESOLUTION AND ASPECT RATIO], clean smooth color, no watermark, no noise, no smudging, no gibberish. All newly added visible text must be in [TARGET MARKET LANGUAGE] and must be exact; preserve any original factory or package artwork.

Then append the scene-specific brief, exact local-language strings, confirmed facts and a negative list of props or claims that must not appear.

## Scene prompt skeleton

```text
Create one complete [RESOLUTION], [ASPECT RATIO] Shopee ecommerce image.
[COMMON PRODUCT-ANCHOR BLOCK]
Visual style: photorealistic real-life setting, bright natural light, lively but not cartoon,
realistic contact shadows, shallow depth of field, restrained props.
Scene / background: [ONE RESOLVED REAL-WORLD CONTEXT: exact location, surface, background arrangement, time/light setup; no alternatives].
Camera / framing: [ONE CAMERA POSITION, VIEWPOINT, LENS/FRAMING AND MAIN ACTION].
Physical logic: [WHAT SUPPORTS EACH PRODUCT/PROP, CONTACT SHADOWS, HAND/WEIGHT RELATIONSHIP, AND OBJECT PLACEMENT].
Product/category: [PRODUCT TYPE].
Composition: [ONE DOMINANT PRODUCT OR FEATURE AND ITS PHYSICAL EVIDENCE].
Main title in a large bold high-contrast rounded rectangle:
"[TITLE IN TARGET MARKET LANGUAGE]".
Supporting line, about 65–75% of title size:
"[SUPPORTING LINE IN TARGET MARKET LANGUAGE]".
Optional qualified disclaimer:
"[DISCLAIMER IN TARGET MARKET LANGUAGE]".
Do not show: [DUPLICATE ITEMS / MISLEADING PROPS / UNCONFIRMED CLAIMS].
```

## Composition matrix

| Purpose | Structure | Proof to show |
|---|---|---|
| Hero | One product or exact variant set, product dominant | The real product in a suitable lifestyle context |
| Options | One space/card per exact color, model, size or finish | Clear option labels; no accidental bundle implication |
| Function | One hero product with one or two clearly separated states | A physical result such as use, before/after, motion, texture or environment |
| Comparison | Clearly separated columns, bordered cards, overlapping cards, or hero-plus-evidence panels; vary the template across a set without losing side ownership | Matched views, visible structure, material macro or other directly comparable evidence |
| Components | Exploded or laid-out components | One separate leader line and local-language label per actual part |
| Portability | Product being carried, stored or used | The actual handle, strap, grip, closure or ergonomic point |
| Dimensions | Clean arrows and labels | Each arrow aligned to the measured feature; values marked approximate when needed |
| Detail macro | One enlarged finish, mechanism, opening, seam, texture or base | A visible physical close-up; callout endpoint touches the feature |
| Lifestyle set | Separate full-frame images for separate situations | One product per scene, with physically plausible secondary props |

## Copy and evidence checklist

Before generation, fill these fields from current evidence:

```text
TARGET MARKET / LANGUAGE:
PRODUCT TYPE:
VARIANTS:
SCENE / BACKGROUND:
COMPARISON LAYOUT / HIERARCHY:
CONFIRMED MATERIALS:
CONFIRMED COMPONENTS:
CONFIRMED DIMENSIONS:
CONFIRMED PERFORMANCE CLAIMS:
QUALIFIERS / DISCLAIMERS:
UNKNOWN OR FORBIDDEN CLAIMS:
TITLE:
SUPPORTING DATA:
VISUAL PROOF:
```

## Scene-first Shopee defaults

- Give every image one resolved plausible use context or visually meaningful contextual background by default. Name one exact location, one surface, one background arrangement, one time/light setup and one camera view; do not put candidate scenes in the prompt.
- Keep the product and advertised feature dominant. Background props frame the product and remain secondary; do not use a busy collage, illustration, or generic decorative scene that obscures the evidence.
- Match the context to the message: use a real opening/packing scene for capacity, a real carrying scene for handles, a close material scene for texture or cleaning, and a clean measurement scene for dimensions.
- Treat an executable prompt as a resolved production brief, not a menu. Do not use unresolved alternatives such as "or", "either", "such as", "for example", slash-separated settings, or "choose". Split alternatives into separate prompts.
- When using an infographic-led composition, specify the exact location of the title strip, supporting pill, product zone, proof element and empty text-safe area. Keep the background at low contrast and explicitly state which props are secondary.

## Physical scene logic

- State the support surface for every product and prop. Require gravity, contact shadows and believable hand contact.
- Keep location semantics coherent: a travel or beauty product normally belongs on a vanity, counter, dressing table, luggage bench, bed or inside a suitcase. Avoid public-floor placement unless the user explicitly requests it and the action is plausible.
- For a carrying action, state which hand holds which handle or strap and how the product's weight is supported. Reject floating, clipping, duplicated hands, impossible grips and props passing through the product.
- Keep scale, depth and ownership clear so background objects do not look included or physically overlap the product.

## Comparison without competitor references

- Use a supplied competitor photo or specification when the user wants a true competitor comparison.
- When no competitor reference exists, use a clearly different, unbranded hypothetical competitor-style comparison object for visible structural contrast. Do not add a visible hypothetical label or disclaimer unless the user requests one. Do not add brand names, logos or trademarks.
- Compare only observable, confirmed differences such as opening layout, pockets, handles or closures. Do not invent competitor performance, scores, durability, water resistance or universal superiority.
- When the purpose is rapid buyer comprehension, make the primary product area and its callouts larger. Keep the comparison object secondary in a distinctly bordered, colored or recessed area rather than blending both objects into one continuous photograph. Use one local comparison marker and keep every limitation visibly tied to the comparison side.
- Follow an explicit user request for a white background when provided, or a marketplace rule that requires it for a primary image; otherwise treat pure white as a review failure for a Shopee set.

Keep the title short and benefit-led. Keep supporting data specific enough to motivate purchase but not so dense that it competes with the product. If a claim cannot be shown visually or verified from the current evidence, remove it or ask the user for confirmation.

## Locale handling

- Use Thai for Shopee Thailand, or the language explicitly requested for another marketplace.
- Preserve brand names and original package/product artwork when they are part of the reference; do not translate or redraw them unless requested.
- Generate the visible copy inside the image. Verify spelling, accents, numerals, units, punctuation and line breaks at thumbnail size.

## Narrow-edit protocol

When the user asks for one pointer, label, prop placement or layout correction:

1. Reuse the previously approved image as the edit reference.
2. State the exact feature and endpoint that must change.
3. Explicitly preserve all other approved product details, typography, lighting, scene and composition.
4. Regenerate only that candidate and recheck the changed region plus the whole thumbnail.

## File convention

Use stable numbered names without hard-coding a product category:

```text
01-hero.png
02-options.png
03-function-proof.png
04-comparison.png
05-components.png
06-portability.png
07-dimensions.png
08-detail.png
09-scene-01.png
10-scene-02.png
11-scene-03.png
```

Change the filenames only when the user's requested deliverable needs another ordering.

