DROP INDEX IF EXISTS idx_posts_metadata_featured;

-- The json field access & casting is required to enable the WHERE clause to use the index.
CREATE INDEX IF NOT EXISTS idx_posts_metadata_featured ON posts(((metadata ->> 'featured')::BOOL));

EXPLAIN ANALYZE
SELECT
  *
FROM
  posts p
WHERE (p.metadata ->> 'featured')::BOOL = TRUE -- Benefited from BTREE index if this path only.
ORDER BY
  (p.metadata ->> 'read_time')::INT DESC
LIMIT 1000;

--                                                                              QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..212.04 rows=1000 width=107) (actual time=0.016..2.011 rows=1000 loops=1)
--    ->  Index Scan Backward using idx_posts_metadata_read_time on posts p  (cost=0.42..105805.79 rows=500000 width=107) (actual time=0.015..1.967 rows=1000 loops=1)
--          Filter: ((metadata ->> 'featured'::TEXT))::BOOLEAN
--          Rows Removed by Filter: 1059
--  Planning Time: 0.453 ms
--  Execution Time: 2.067 ms
