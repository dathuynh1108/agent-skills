# Database Performance Review

- Confirm the exact query shape after ORM generation.
- Check filters, joins, ordering, and selected columns.
- Look for N+1 query loops and per-row external calls.
- Check indexes against equality/range/order requirements.
- Avoid fetching whole rows when only a few columns are needed.
- Keep transactions short and away from slow network calls.
- Use cursor/keyset pagination for high-offset paths when appropriate.
- Validate with query plan, query count, or benchmark when available.
