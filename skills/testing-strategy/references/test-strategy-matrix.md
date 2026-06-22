# Test Strategy Matrix

| Change type | Minimum useful tests |
| --- | --- |
| Pure function/business rule | Unit tests with edge cases |
| API handler | Handler tests + contract/error cases |
| DB query/repository | Integration test + query count/plan when hot |
| Migration | Migration test/dry-run + compatibility check |
| Queue worker | Duplicate/retry/dead-letter tests |
| External client | Adapter tests with timeout/error mapping |
| Refactor | Characterization tests before broad edits |
| Performance fix | Regression test + before/after metric |
| ML data pipeline | Schema/data quality/time-leakage checks |
| Model inference | Output shape + latency/memory where possible |
