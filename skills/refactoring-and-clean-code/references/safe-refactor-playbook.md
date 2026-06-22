# Safe Refactor Playbook

## Sequence For Risky Refactors
1. Characterize current behavior.
2. Make mechanical rename/move only.
3. Run tests.
4. Extract/simplify one concept.
5. Run focused tests again.
6. Review diff for behavior changes.
7. Commit or report separately from feature changes.

## Red Flags
- No tests around changed behavior.
- Public API or persisted data shape changes.
- Generated files not regenerated.
- Cross-module dependency direction changes.
- Error handling becomes less specific.
