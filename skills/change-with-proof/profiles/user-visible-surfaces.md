# User-Visible Surfaces

## Trigger

Rendering, interaction, product copy, emails, notifications, exports, PDFs, reports,
user-facing logs, end-user docs, or other generated user-facing content.

## Additional obligations

- Inventory the surface before changing it: surface (route/component/template/export/email/
  log/doc), audience (end user, admin/operator, developer, demo), the user's task, the state
  the surface must communicate, the next action or recovery path, and the proof path.
- Audience/layer rule: the wrong audience must never see the wrong layer. Check for
  implementation mechanics presented as product value; agent/process artifacts and planning
  notes; debug traces, hidden IDs, or internal state names; fallback rationale shown as normal
  UX; secrets; demo/mock wording on committed surfaces. Move necessary internals to code,
  tests, operator logs, or admin/debug surfaces.
- Required states: a surface that renders async data defines **populated**, **loading**,
  **empty**, and **error** states. Empty is a designed state — never a blank page or a raw
  `[]`/`null`. Loading never silently presents stale content as fresh. Error states
  distinguish at least network failure, permission denied, and partial data, each with a
  recovery path in product terms.
- Error copy says what happened in product terms, what it affects, and what the user can do
  next — no stack traces, internal IDs, or implementation branches.
- Locale and formatting: when the surface is localized or shows dates, numbers, or currency —
  correct locale formatting, pluralization, and a defined missing-translation behaviour (an
  end user never sees the raw key).
- Prove with rendered output: browser path for route/flow changes; rendered component or
  template snapshot for isolated stable units; golden diff for exports, emails, PDFs, and
  reports; screenshot only when it proves the surface and audience are correct.

## Characteristic failure modes

- Raw `null`, `[]`, or `NaN` rendered to an end user.
- Blank flash or spinner-forever because loading/empty states were never designed.
- One generic error message covering network failure and permission denial alike.
- Missing-translation key or wrong-locale currency/date shown verbatim.
- Stack trace, internal ID, or process narration on an end-user surface.
- Helper-level test passed off as proof for a rendered surface.

## Minimum evidence

- Rendered proof of the populated state plus every state the change touches (loading, empty,
  error when async data is involved).
- Golden diff for generated artifacts; locale-specific render when localized.

## Exit criteria

- Every state the change touches is designed and proven with rendered output.
- No cross-audience leakage on any changed surface; copy is in product language.
