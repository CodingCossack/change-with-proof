# UI and Product Boundary Workflow

Use for UI, product copy, emails, notifications, exports, PDFs, reports, user-facing logs, end-user docs, or generated content.

## Surface inventory

Before changing visible output, identify:

- Surface: route/page/component/template/export/email/log/doc/PDF/report.
- Audience: end user, admin/operator, developer/debug, internal maintainer, demo/test user.
- User task: what the audience is trying to do.
- Product state/outcome: what the surface should communicate.
- Next action or recovery path: what the audience can do next.
- Internal vocabulary allowed for this audience.
- Proof path: browser smoke, rendered snapshot, golden diff, route crawl, screenshot, or targeted text review.

## Positive target

User-facing surfaces should expose domain state and user actionability: task, state, outcome, next action, and recovery path. They should not make the user understand the implementation to use the product.

Admin/operator surfaces may expose operational facts when those facts support decisions. Developer/debug surfaces may expose internals when intentionally separated and clearly labelled. Developer docs may be technical; end-user docs should use product/domain language.

## Leak classes to check

The problem is not a specific word. The problem is the wrong audience seeing the wrong layer. Check for:

- Implementation mechanics presented as product value.
- Agent/development process, research notes, planning artifacts, or replacement history.
- Debug traces, stack traces, raw telemetry, hidden IDs, internal state names, or storage keys on end-user surfaces.
- Fallback/degraded-mode rationale shown as normal UX.
- Secrets, sensitive metadata, or private operational details.
- Demo/mock/prototype wording on committed product surfaces.

Move necessary internals to code, tests, operator logs, admin/debug routes, or internal/developer docs.

## Error and empty states

A user-facing failure state should say what happened in product terms, what it affects, and what the user can do next. It should not leak stack traces, internal IDs, implementation branches, or agent/process history.

## Proof

Prefer rendered-output proof:

- Browser path for route/user-flow changes.
- Rendered component/template snapshot when the unit is isolated and stable.
- Export/email/PDF/report golden diff for generated user content.
- Targeted visible-text scan on product routes/surfaces when useful.
- Screenshot/trace only when it proves the surface and audience are correct.
