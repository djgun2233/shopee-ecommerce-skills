---
name: shopee-product-imagegen
description: Create or revise photorealistic Shopee ecommerce product-image sets for any physical product with exact reference fidelity, configurable marketplace language, contextual scenes, and evidence-led feature visuals.
metadata:
  short-description: Reproduce a consistent Shopee product-image style
---

# Shopee product-image generation

Use this skill when the user wants a Shopee listing image, a complete image set, or a revision of an existing product image. It is product-agnostic: the current reference photos and confirmed specification sheet always override examples in this skill.

## Generation rules

- Use Codex's built-in image generation/editing tool and its included quota. Do not use an image API, external browser, or post-generation text overlay unless the user explicitly asks for one.
- Respect the user's requested resolution and aspect ratio. If none is supplied, default to the proven ecommerce format `2048×2048`, `1:1`.
- Use the supplied product image(s) as the visual anchor with `referenced_image_paths`. Never invent a replacement product when a reference exists. If a necessary reference is missing, ask for it rather than guessing.
- Lock the product's outer geometry before changing scene or camera: preserve the reference silhouette, width-to-height ratio, depth, handle height, corner radius and panel proportions without independent horizontal or vertical stretching. A lifestyle background is never permission to flatten, widen, slim or otherwise reshape the product.
- Generate each finished image as a complete composition. Newly added text must be rendered inside the generated image; if text is wrong or garbled, regenerate rather than patching it afterward.
- Before prompting, make a small product truth table: variants, colors, silhouette/proportions, materials, components, printed artwork, measurable dimensions, confirmed benefits, and explicitly unknown claims. Every image must stay inside that table.
- For opened, unfolded or exploded views, also make a structure map before prompting: which panels remain attached, hinge or fold directions, zipper paths, compartment count, divider positions, pocket locations and which surfaces face the camera. The latest user-confirmed structure reference overrides earlier generic examples. Never infer a generic interior from an exterior-only photo when a structural reference exists.
- Default to the exact current-product exterior photo. Add structure-only crops only when the advertised feature is hidden, open, folded, internally organized or otherwise ambiguous enough that the generator could invent it. Use the minimum relevant crops for that one image; do not attach every available crop to every prompt. When a useful structural reference contains unrelated marketing text, layout, people, props or another visual style, make a tight crop in the task's working folder and label its role. Keep enough surrounding geometry to prove attachment points, fold direction, zipper path and scale; never crop a component so tightly that it looks detached or changes the inferred topology. Crops are reference inputs only, not final-image compositing.
- For a multi-image set, prepare a complete prompt brief for every final image before starting the first generation. Each brief must name the reference paths, scene/background, dominant message, visible proof, exact added copy, and negative list. If the user asks to review prompts first, show the full set and wait for approval before generating.

## Mandatory execution gate

Use this gate on every Shopee image task; it is part of the deliverable, not optional advice.

Before generation or editing:

- Write a compact current-product truth table with `confirmed`, `unknown`, and `forbidden` fields. The latest explicit user confirmation overrides an older job brief. Never turn a one-product prohibition into a universal rule, and never carry another product's claims into this job.
- Classify every input as `edit target`, `product anchor`, `structure/evidence reference`, or `style reference`. Record the exact path and the fact it is allowed to contribute.
- For a set, create a prompt manifest before the first image call. Every record must contain a stable filename, one resolved scene, one dominant message, exact visible copy, physical proof, references and negative list.
- If the request also asks for listing copy, route that part through the available e-commerce title/description skill or explicitly mark it as outside the image deliverable. Do not silently substitute a generic translation.

Before delivery:

- Check each candidate at full resolution and thumbnail scale for reference fidelity, geometry, physical support, text, arrows, claims, watermarks, resolution and aspect ratio.
- Reconcile the final files against the manifest and output folder. A missing requested asset, stale prohibition, unchecked character/text error or failed visual check blocks handoff; regenerate or report the exact blocker.
- In the final handoff, state the skills used, the files delivered, the validations passed and any remaining qualifier. Do not claim completion from generation success alone.

## Accepted Shopee visual language

- Default to photorealistic lifestyle ecommerce photography: bright, warm, colorful, energetic and inviting, with a specific real-world scene or contextual background for each image. Do not default to a pure white or empty studio background; use one only when the user explicitly requests it or a marketplace primary-image requirement explicitly calls for it.
- Choose one specific scene that supports the product's actual use or the feature being proved. Resolve the exact location, surface, background arrangement, time/light setup, camera position and main action before generation; keep the scene believable and secondary, and do not let props cover or compete with the product.
- Use a real, plausible use context that creates buying desire: home, desk, commute, kitchen, outdoors, travel, sport, beauty, storage, or another setting appropriate to the product. Use natural light, believable contact shadows, realistic depth of field and smooth clean color.
- The product or advertised feature should receive roughly 45% or more of the viewer's attention. Props frame the product and normally stay at 20% or less; never let bags, food, flowers, devices, people or scenery compete with or cover the product.
- When the requested set is information-led, use a product-centered infographic hierarchy: one large rounded title bar at the top, an optional shorter supporting pill beneath it, a dominant product zone, and only the evidence cards or callout lines needed for that image's one message. Borrow the hierarchy, spacing, rounded cards, restrained color coding and soft background treatment from a style reference without copying its product content.
- Keep the visual order stable at thumbnail size: title first, exact product or feature second, proof and labels third, background last. The background is a low-contrast context layer; it must never become a large person, busy collage, oversized prop or competing focal point.
- In a multi-image set, vary scenes at a deliberate cadence rather than changing location in every frame or repeating one location for the whole set. A useful default is to keep one coherent scene family for two or three adjacent images, then switch when the next selling message benefits from another context. Preserve the set's typography, card system, color rhythm and product scale across scene changes.
- Give each image one dominant selling message. Do not introduce duplicate products that could be mistaken for included items unless the image explicitly communicates variants or a bundle. 
- Keep the final frame clean: no watermark, source-site logo, noise, smudged edges, warped hands, floating parts, gibberish, accidental accessories or physically impossible object placement.

## Transferring visual style from reference images

- Classify every supplied image before prompting: product anchor, structural/evidence reference, or style reference. A style reference may contribute only visual organization such as title-bar treatment, card hierarchy, comparison layout, color rhythm, background blur, macro inset, or arrow treatment. It never contributes the other product's material, dimensions, colors, performance claims, accessories, food, people, packaging text or implied test results.
- Do not attach a style-only image as `referenced_image_paths` when generating a different product unless the tool call explicitly supports style-only conditioning and the prompt clearly prevents product contamination. Convert the observed style into words and attach only the current product and relevant structural references.
- A reusable product-centered information-image layout is: top title strip with one exact local-language headline; optional supporting pill with one short line; a central product occupying about 55–70% of the meaningful content area; one to three rounded evidence cards, leader lines or a single macro inset; and a restrained, softly blurred real setting behind the composition. Leave clean negative space for text and never cover the product with the header.
- Use distinct proof modules for distinct messages: a circular or rounded macro inset for a small material or mechanism detail, a short leader line with a dot endpoint for a physical feature, clean double-headed arrows for dimensions, and an asymmetric comparison with the real product visibly larger than an unbranded hypothetical comparison object. Do not mix all modules into one frame.
- For a multi-SKU hero, use controlled product placement rather than a lifestyle collage: one space per exact variant, equal visual access to every option, clear color labels, a quiet background and no large human subject. The products must remain the first visual read.
- Use card color as a hierarchy cue, not as a new claim. A dark title bar, warm accent pill, white evidence card and thin outline are acceptable generic treatments; the chosen colors must not imply unverified performance. Any text visible in a reference image is style inspiration only and must be rewritten from the current product truth table.
- Do not use a multi-panel collage merely because a reference contains one. Choose a single full-frame scene when a collage would make the product too small or blur the proof; use panels only when the requested message genuinely compares states, options or use contexts.

## Scene logic and physical plausibility

- Resolve the physical support for every product and prop: name the exact table, counter, bench, bed, suitcase interior or hand that supports it. Every object must obey gravity and have believable contact shadows or hand contact.
- Keep the setting semantically coherent. Use a counter, vanity, dressing table, luggage bench, bed or suitcase interior for travel and beauty products; do not place a product directly on a public or crowded floor unless the user explicitly requests that action and the scene makes it safe and plausible.
- For every carrying or handling action, define what is bearing the product's weight and how the hand, handle, strap or closure is connected. Do not show floating bags, clipped surfaces, impossible grips, duplicated hands or props passing through the product.
- In person-in-use lifestyle images, show one specific action that proves the intended use: packing, opening, removing an item, carrying, placing into luggage or another product-relevant action. Keep the product and contact action sharper and larger than the person's face or outfit; the person provides scale and use evidence rather than becoming the hero. Define each hand's role, keep the product unobstructed and reject anatomically incorrect fingers or weightless contact.
- Keep scale, depth and object ownership consistent. Background suitcases, furniture and props must occupy physically plausible positions and must not imply that demonstration props are included.

## Language and typography

- Use the marketplace language requested by the user. For Shopee Thailand, newly added copy is Thai; for another market, use that market's language. Preserve original packaging or factory artwork on the product, but do not add unrelated English or Chinese copy.
- Put one large bold main title in a high-contrast rounded rectangle with a thin outline or clear edge. It must be the first readable element at phone-thumbnail size and must not cover the product.
- Supporting feature/data copy should be readable and normally about 65–75% of the title size. A legal or measurement disclaimer may be smaller, but essential data must not be tiny.
- Check every glyph, accent, number, unit, punctuation mark and line break before accepting the image. Keep text boxes clear of product details, leader lines and measurement arrows.

## Evidence-led selling

- Every functional or comparative claim should have a visible proof element, not only a sentence beside the product: physical use, before/after state, condensation/steam, material macro, component separation, measurement arrows, capacity demonstration, texture close-up, or another product-specific proof.
- Show only facts confirmed by the current references or explicitly confirmed by the user. Evaluate every performance, safety, certification, compatibility, capacity, durability, water-resistance or other claim from the current product truth table; never carry a prior product's prohibition or approval into a new job. A confirmed claim may be used with the appropriate qualifier, while an unconfirmed claim must be omitted rather than guessed.
- When a comparison is relevant, make the two sides unmistakably separate at first glance. Acceptable structures include full-height columns, two bordered photographic cards, a larger foreground card beside a smaller recessed card, or a hero product beside two distinct evidence panels. Use borders, gutters, background-color shifts, depth, headers and a `VS` or equivalent local-language marker to establish ownership. Never imply a generic comparison is a certified test.
- When the user wants a selling-point comparison, use an asymmetric hierarchy: let the primary product occupy roughly 55–70% of the visual area, give its advantages the largest readable callouts, and place the comparison product in a smaller 25–35% card with concise, visibly grounded limitations. Keep a center divider or local comparison marker; use equal columns only when matched views are the actual purpose.
- Do not force one comparison template across a set. Alternate between separated columns, overlapping bordered cards and hero-plus-evidence-board layouts when the message benefits, while preserving a consistent typography and color system. A continuous center divider is optional; clear visual ownership is mandatory. If the two sides look like one uninterrupted photograph, if labels appear to apply to both products, or if the comparison boundary disappears at thumbnail size, regenerate.
- If no competitor reference is supplied, do not invent a branded or market-specific competitor. For visual structural contrast, use a clearly unbranded hypothetical competitor-style comparison object internally. A visible hypothetical or disclaimer label is optional and should not be added unless the user requests it. Claim only visible, reference-confirmed differences; do not assign scores or imply universal superiority.
- When a leader line or callout is used, its endpoint must touch the exact physical feature being named. Separate lines must end on separate parts; no line may terminate in air, on a neighboring part, or on the wrong side of the product.
- For dimensions, first map each value to an exact pair of physical endpoints and confirm whether height means body height or overall height including handles, lid, straw or another protrusion. Default to clean double-headed arrows and large labels rather than a ruler or tape measure. Align width, depth and height arrows with their actual projected edges; both endpoints must touch the intended corners or boundary guides. Mark values as approximate when they are hand-measured. Add a ruler only if the user specifically wants one and the visual evidence remains correct.
- If perspective makes the depth endpoint ambiguous, do not force a diagonal arrow across the hero view. Use a separate restrained side-profile inset derived from the confirmed product/reference, with one horizontal depth arrow touching the frontmost and rearmost side boundaries. Keep width and overall height on the main view. Never invent a side silhouette that contradicts the exterior anchor.

## Reusable composition modes

Select the mode that matches the requested message; read [references/style-and-prompts.md](references/style-and-prompts.md) for the prompt skeleton.

1. **Hero / variants** — one product or the exact set of variants, with the product dominant and a short title.
2. **Color, model or finish choice** — isolate each exact option in a restrained card or scene and label the options clearly so they are choices, not accidental included items.
3. **Function proof** — use one hero product and split the visual evidence only when it clarifies two states (for example, before/after or warm/cool); make each side's evidence unmistakable.
4. **Material or competitor comparison** — use matched columns when equivalence matters, or an asymmetric primary-product/secondary-competitor layout when the goal is rapid buyer comprehension; use a center divider and local comparison marker with concise confirmed differences and real evidence.
5. **Components / exploded view** — lay out removable or important parts realistically; use one correctly terminating labeled leader line per part.
6. **Portability / ergonomics** — show the actual strap, grip, closure, handle or carrying action in a plausible use context; callouts point to the exact surface.
7. **Dimensions / scale** — use arrows and large measurements, with no clutter and no contradictory reference objects.
8. **Detail macro** — enlarge one material, finish, opening, mechanism or base detail; preserve the approved composition when the user asks for a narrow pointer/placement fix.
9. **Standalone lifestyle scenes** — create separate full-frame images for separate contexts, not a three-way split panel, unless the user explicitly requests a collage. Keep bags, devices and props physically plausible and secondary.
10. **Product-centered infographic** — combine one dominant product view with a restrained title strip, short supporting pill, one to three evidence cards, a macro inset or precise leader lines; keep the background soft and subordinate and do not overload the frame with unrelated modules.

## Prompt-first batch workflow

- For each requested image, write the prompt before any image-generation call and assign a stable filename.
- The prompt must specify: exact product references, target resolution/aspect ratio, scene/background, camera/composition, one dominant selling message, physical proof, exact marketplace-language copy, and prohibited claims or objects.
- If a style reference is being used, add a short style-lock block to each relevant prompt that names only the transferable visual devices (for example: top title strip, supporting pill, rounded evidence card, macro inset, arrow style, or asymmetric comparison). Do not name the reference product as something to reproduce.
- If structure-only crops are used, list each crop by role in the prompt and state which structural facts it may contribute. Do not let crop backgrounds, source text or source layout override the current scene and typography brief.
- Every executable prompt must be decision-complete: exactly one location, one surface, one background arrangement, one time/light setup, one camera position and one main action. Do not write unresolved alternatives with words such as "or", "either", "such as", "for example", slash-separated settings, or "choose". If multiple settings are desired, create separate prompt records instead of combining them.
- Use distinct but coherent contexts across a set when they clarify different buying reasons; do not repeat a blank backdrop for every image.
- If the user requests prompt review, do not generate a partial batch. Revise the manifest until the user approves it, then generate in filename order.
- If one generated image fails review, revise or regenerate only that image and preserve approved images.

## Buyer-perspective acceptance pass

Inspect every image at full resolution and phone-thumbnail scale:

- Is the product/feature immediately identifiable and faithful to the current reference?
- Does the product preserve the reference width-to-height ratio, depth, handle height, corner radius and panel proportions without horizontal stretching or vertical compression?
- If the product is open or unfolded, do the panel topology, fold directions, compartments, dividers, pockets and zipper paths match the confirmed structure reference?
- Is there one dominant title in a rounded box, with readable supporting information at roughly 65–75% of title size?
- If the set uses the infographic style, is the visual hierarchy still title → product/feature → proof → background at phone-thumbnail size?
- Are title bars, pills, cards and panels restrained enough that they support the product rather than becoming the main subject?
- Does each arrow, pointer or label end on the intended physical feature rather than air, another part or the base?
- Does the visual evidence substantiate the stated feature instead of merely repeating it in text?
- Are props plausible, restrained and free of “included item” ambiguity?
- Is all new copy in the requested marketplace language, legible and typo-free?
- Are claims limited to confirmed specifications, with qualifiers where measurement or performance depends on use?
- Is the frame free of watermark, noise, smudging, warped objects and unwanted redesign?

Regenerate only the failing image, preserving approved images. For a requested small pointer, label or prop-placement fix, make the narrowest possible edit and do not redesign the rest of the image.

## Delivery

Use clear numbered filenames (`01-hero.png`, `02-options.png`, etc.), verify the requested resolution/aspect ratio, and copy only buyer-approved versions to the requested output folder. Keep superseded drafts outside the final deliverable directory.

