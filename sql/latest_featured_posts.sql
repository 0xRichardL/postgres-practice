EXPLAIN ANALYZE
SELECT
  *
FROM
  posts p
WHERE (p.metadata ->> 'featured')::BOOL = TRUE -- Benefited from BTREE index if this path only.
ORDER BY
  (p.metadata ->> 'read_time')::INT DESC
LIMIT 1000;

