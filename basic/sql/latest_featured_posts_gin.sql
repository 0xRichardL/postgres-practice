DROP INDEX IF EXISTS idx_posts_metadata;

CREATE INDEX IF NOT EXISTS idx_posts_metadata ON posts USING GIN(metadata);

DROP INDEX IF EXISTS idx_posts_metadata_featured;

-- Json field access & casting is required to sort by read_time efficiently, by number order not string lexicographic order.
CREATE INDEX IF NOT EXISTS idx_posts_metadata_read_time ON posts(((metadata ->> 'read_time')::INT));


/*
This query uses a GIN index on the metadata JSONB column to efficiently filter for featured posts.
It then orders the results by read_time in descending order and limits to 1000 rows.
 */
EXPLAIN ANALYZE
SELECT
  *
FROM
  posts p
WHERE
  p.metadata @> '{"featured": true}' -- Benefited from GIN index, by `@>`.
ORDER BY
  (p.metadata ->> 'read_time')::INT DESC -- Must cast to INT for correct ordering.
LIMIT 1000;

--                                                                              QUERY PLAN
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..200.09 rows=1000 width=107) (actual time=0.852..20.240 rows=1000 loops=1)
--    ->  Index Scan Backward using idx_posts_metadata_read_time on posts p  (cost=0.42..100843.68 rows=505051 width=107) (actual time=0.852..20.178 rows=1000 loops=1)
--          Filter: (metadata @> '{"featured": true}'::JSONB)
--          Rows Removed by Filter: 1059
--  Planning Time: 1.359 ms
--  Execution Time: 20.332 ms
