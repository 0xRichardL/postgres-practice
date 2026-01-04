EXPLAIN ANALYZE
SELECT
  *
FROM
  posts p
WHERE (p.metadata ->> 'featured')::bool = TRUE -- Benefited from BTREE index if this path only.
ORDER BY
  (p.metadata ->> 'read_time')::int DESC
LIMIT 1000;

--                                                                              QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.42..215.16 rows=1000 width=107) (actual time=0.364..33.766 rows=1000 loops=1)
--    ->  Index Scan Backward using idx_posts_metadata_read_time on posts p  (cost=0.42..53635.59 rows=249767 width=107) (actual time=0.363..33.675 rows=1000 loops=1)
--          Filter: ((metadata ->> 'featured'::text))::boolean
--          Rows Removed by Filter: 938
--  Planning Time: 3.527 ms
--  Execution Time: 34.079 ms
-- (6 rows)
