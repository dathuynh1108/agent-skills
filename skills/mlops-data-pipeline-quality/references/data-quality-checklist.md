# Data Quality Checklist

## Schema
- Required fields present.
- Types match contract.
- Nullability is intentional.
- Enum/domain values are valid.

## Volume And Freshness
- Row/event count within expected range.
- Partitions complete.
- Lag below SLA.
- Late data handled.

## ML-Specific
- No target leakage.
- Time split mirrors production timing.
- Feature defaults match serving path.
- Labels are delayed and versioned when needed.
- Evaluation slices cover known risk groups.
