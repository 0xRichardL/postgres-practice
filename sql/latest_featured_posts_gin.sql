EXPLAIN ANALYZE
SELECT
  *
FROM
  posts p
WHERE
  p.metadata @> '{"featured": true}' -- Benefited from GIN index.
ORDER BY
  (p.metadata ->> 'read_time')::int DESC
LIMIT 1000;

--                                                                              QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..206.98 rows=1000 width=107) (actual time=0.186..34.515 rows=1000 loops=1)
--    ->  Index Scan Backward using idx_posts_metadata_read_time on posts p  (cost=0.42..51118.40 rows=247475 width=107) (actual time=0.185..34.436 rows=1000 loops=1)
--          Filter: (metadata @> '{"featured": true}'::jsonb)
--          Rows Removed by Filter: 938
--  Planning Time: 1.492 ms
--  Execution Time: 34.753 ms
-- (6 rows)
