---
name: refactoring-and-clean-code
description: Use for language-agnostic clean code, safe refactoring, simplification, renaming, extraction, reducing duplication, reducing complexity, improving readability, or cleaning code while preserving behavior. Do not use for feature changes unless requested.
---

# Refactoring And Clean Code

## Workflow

1. Identify whether the task is behavior-preserving refactor, cleanup, or feature change. Do not mix them silently.
2. Read existing tests and nearby code before editing. If behavior is unclear, add or recommend characterization tests first.
3. Make the smallest refactor that improves the requested issue.
4. Preserve public contracts, edge cases, error behavior, logging semantics, and generated artifacts unless explicitly changed.
5. Prefer clear names, direct control flow, small cohesive functions, and local reasoning.
6. Review the diff for accidental behavior changes and unrelated formatting.
7. Run focused tests and formatting/lint/typecheck commands from the repo.

## Clean Code Checks

- Names reveal domain intent without encoding implementation noise.
- Functions/classes/modules have one clear reason to change.
- Complex conditionals are named or decomposed when it improves readability.
- Duplication is removed only when the shared abstraction is real and stable.
- Dependencies point in the existing architectural direction.
- Error handling is explicit and not swallowed.
- Side effects are visible at call sites or isolated behind existing boundaries.
- Comments explain why, not what the code already says.
- Dead code is removed only when proven unused by the current change or requested cleanup.
- Formatting follows repo tooling, not personal preference.

## Refactoring Moves

- Rename: update all references, tests, docs, and generated artifacts when needed.
- Extract function: extract around a named concept, not arbitrary line count.
- Extract module/class: do it only when ownership or testability improves.
- Inline abstraction: remove wrappers that hide behavior without value.
- Split large change: separate mechanical move/rename from behavior change.
- Simplify conditionals: preserve truth table and add edge tests when risk exists.

## Anti-Patterns

- Do not rewrite a working subsystem for style.
- Do not introduce abstractions for one implementation unless a boundary needs protection.
- Do not change tests only to match accidental new behavior.
- Do not collapse explicit business rules into clever generic helpers.
- Do not mix cleanup with unrelated feature work in one commit unless the user asked.

## Output

Report:

- Refactor intent.
- Behavior preserved or intentionally changed.
- Tests/checks run.
- Risky areas reviewed.
- Follow-up cleanup, if any, kept separate.

Use `references/safe-refactor-playbook.md` for risky or cross-module refactors.
