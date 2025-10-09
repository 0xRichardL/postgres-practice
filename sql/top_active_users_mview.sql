CREATE MATERIALIZED VIEW IF NOT EXISTS top_users_by_views AS (
  SELECT
    user_id,
    count(post_id) AS views
  FROM
    post_views
  GROUP BY
    user_id
  ORDER BY
    views DESC);

CREATE INDEX IF NOT EXISTS idx_top_users_by_views_views ON top_users_by_views(views);

EXPLAIN ANALYZE
SELECT
  u.id,
  u.username,
  tu.views
FROM
  top_users_by_views tu
  INNER JOIN users u ON u.id = tu.user_id
ORDER BY
  tu.views DESC
LIMIT 5;

--                                                            QUERY PLAN
-- ---------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=70.75..70.76 rows=5 width=25) (actual time=1.645..1.646 rows=5 loops=1)
--    ->  Sort  (cost=70.75..73.25 rows=1000 width=25) (actual time=1.643..1.645 rows=5 loops=1)
--          Sort Key: uv.views DESC
--          Sort Method: top-N heapsort  Memory: 25kB
--          ->  Hash Join  (cost=33.50..54.14 rows=1000 width=25) (actual time=0.992..1.452 rows=1000 loops=1)
--                Hash Cond: (uv.user_id = u.id)
--                ->  Seq Scan on user_views uv  (cost=0.00..18.00 rows=1000 width=12) (actual time=0.089..0.391 rows=1000 loops=1)
--                ->  Hash  (cost=21.00..21.00 rows=1000 width=17) (actual time=0.858..0.859 rows=1000 loops=1)
--                      Buckets: 1024  Batches: 1  Memory Usage: 57kB
--                      ->  Seq Scan on users u  (cost=0.00..21.00 rows=1000 width=17) (actual time=0.007..0.593 rows=1000 loops=1)
--  Planning Time: 5.994 ms
--  Execution Time: 1.852 ms
-- (12 rows)
--
--                                                             QUERY PLAN (with index)
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.55..2.54 rows=5 width=25) (actual time=0.132..0.228 rows=5 loops=1)
--    ->  Nested Loop  (cost=0.55..398.70 rows=1000 width=25) (actual time=0.131..0.226 rows=5 loops=1)
--          ->  Index Scan Backward using idx_user_views_views on user_views uv  (cost=0.28..42.28 rows=1000 width=12) (actual time=0.096..0.097 rows=5 loops=1)
--          ->  Index Scan using users_pkey on users u  (cost=0.28..0.36 rows=1 width=17) (actual time=0.019..0.019 rows=1 loops=5)
--                Index Cond: (id = uv.user_id)
--  Planning Time: 1.909 ms
--  Execution Time: 0.375 ms
-- (7 rows)
