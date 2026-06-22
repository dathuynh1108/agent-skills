# Instrumentation Checklist

- Which user/system impact should be visible?
- Which boundary should emit the signal?
- Is cardinality bounded?
- Are identifiers safe to log?
- Is the signal actionable?
- Can it distinguish dependency failure from application bug?
- Does it add unacceptable hot-path cost?
