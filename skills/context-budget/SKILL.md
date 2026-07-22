---
name: context-budget
description: Keep Codex repository exploration focused without reducing model context or capabilities. Use for unfamiliar or large codebases, architecture or execution-flow tracing, large logs/test output, long-running tasks, repeated compaction, or whenever the agent is reading many files without converging on the requested work.
---

# Context Budget

## Define The Evidence

- Restate the concrete question and the evidence needed to answer it.
- Keep root context for the request, constraints, decisions, and acceptance checks.
- Preserve the full model context and available capabilities. Optimize what is
  retrieved, not how much the model is allowed to use.
- Request the smallest representation that answers the current question, then
  expand whenever omitted detail could change correctness or risk.

## Retrieve In Layers

1. Check the nearest instructions and current dirty state.
2. If an index is available and fresh, use graph/symbol lookup to identify the
   owner, callers, callees, process, or blast radius.
3. Use `rg --files`, `rg -l`, or exact-pattern search to verify current paths and
   literals without printing bodies.
4. Read the owning symbol or a narrow line range plus the nearest relevant test.
5. Expand one edge at a time only when the current evidence leaves a named gap.

Use GitNexus for graph relationships and execution flow. Use Serena symbol tools
when available for definitions, references, and symbol-body edits. Use `rg` for
exact text and fresh dirty-tree truth.

## Control Output

- Filter logs by request ID, error, time window, pod/process, or component before
  reading them. Prefer counts plus the last relevant lines.
- Run focused tests first. Capture the failing node/error, not the entire suite.
- Summarize large query results in the producing command; do not paste raw rows.
- Keep raw artifacts available on disk and reopen exact sections when needed; do
  not discard evidence merely to satisfy an arbitrary size threshold.
- Avoid combined commands that concatenate unrelated files or reports.
- Keep evidence paths and exact commands so details can be re-opened on demand.

## Stop And Checkpoint

- Stop exploration once the owner, relevant flow, contract, and validation path
  are known. Proceed with the requested diagnosis, review, or change.
- After two searches that add no new evidence, change retrieval strategy instead
  of widening the same search.
- Before an intentionally large phase, checkpoint only: current goal, verified
  decisions, changed files, checks run, and remaining work.
- Compact only when remaining context threatens task completion, and continue
  from the checkpoint instead of restarting discovery.
