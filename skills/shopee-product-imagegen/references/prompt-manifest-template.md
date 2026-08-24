# Prompt manifest template

Use one record per requested image and finish the record before any image-generation call.

```yaml
id: "01"
filename: "01-descriptive-name.png"
resolution: "2048x2048"
aspect_ratio: "1:1"
mode: "hero | feature | comparison | dimensions | lifestyle"

product_references:
  - path: "exact product-reference path"
    role: "exterior product anchor"
structure_references:
  - path: "optional exact crop path"
    role: "only the named structure facts"
style_reference:
  transfer_only: "title hierarchy, rounded cards, inset, arrows, or comparison layout"

scene_lock:
  location: "one exact real-world location"
  support_surface: "one exact surface or hand that supports every object"
  background: "one restrained arrangement behind the product"
  light: "one time and lighting setup"
  camera: "one angle, distance, and focal priority"
  action: "one physically plausible action, if applicable"

composition:
  dominant_message: "one buying reason"
  product_zone: "product remains the first visual read"
  proof_element: "visible proof for the stated feature"
  text_safe_area: "exact area reserved for generated text"

visible_copy:
  language: "requested marketplace language"
  title: "exact title text"
  support: "exact supporting text, if needed"
  labels: ["exact labels only"]

negative_constraints:
  - "no unconfirmed claims"
  - "no extra colors, accessories, logos, watermarks, or unrelated text"
  - "no floating objects, impossible grips, clipped hands, or incorrect scale"

acceptance:
  - "reference fidelity"
  - "text, numerals, units, and line breaks"
  - "thumbnail readability"
  - "arrows and leader-line endpoints"
```

## Prompt completion rules

- Resolve exactly one location, surface, background arrangement, light setup, camera view, and action. Do not write unresolved alternatives such as “or”, “either”, “such as”, “for example”, slash-separated settings, or “choose”.
- Name every attached reference by role. A style reference contributes visual organization only; it must not contribute another product's facts, colors, accessories, text, or performance claims.
- Use a structure crop only when the exterior reference cannot communicate the required topology. State which facts the crop may contribute and ignore its background and source text.
- Keep one dominant selling message per image. Make the product or proof element larger and sharper than the scene props.
- For comparisons, establish visible ownership with separate columns, borders, gutters, color blocks, depth, or a local comparison marker. Use only observable differences.
- For dimensions, map every arrow to two physical endpoints before generation. Mark measurements as approximate when the source measurement is approximate.

