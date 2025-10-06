SET enable_seqscan = OFF;

EXPLAIN ANALYZE
SELECT
  *
FROM
  posts p
WHERE
  p.metadata @> '{"featured": true}' -- Benefited from GIN index.
ORDER BY
  (p.metadata ->> 'read_time')::INT DESC
LIMIT 1000;

