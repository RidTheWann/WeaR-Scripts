# Contributing to WeaR-Scripts

## Before opening a pull request

Please test changes in the intended Roblox experience and describe the executor/runtime assumptions in the pull request.

Keep changes focused. Prefer small, reviewable commits over unrelated feature bundles.

## Lua guidelines

- Keep reusable behavior in modules rather than duplicating logic.
- Guard optional executor APIs before calling them.
- Avoid tight loops without a sensible task yield or debounce.
- Keep user-facing warnings accurate, especially for features that may trigger game moderation.
- Do not include credentials, tokens, private endpoints, or personal data in commits.

## Pull request checklist

- Explain the problem and the change.
- Include reproduction steps for bug fixes.
- Mention compatibility assumptions or limitations.
- Test the affected path before requesting a merge.
