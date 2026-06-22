# Index Review Checklist

- Does the index match equality filters before range filters?
- Does it support the order by clause?
- Is cardinality high enough to be useful?
- Is there an existing index that already covers the query?
- Will the new index slow write-heavy paths too much?
- Can the index be created online in the target DB?
- Does pagination use stable ordering and bounded limits?
- Is the query tenant-scoped where required?
