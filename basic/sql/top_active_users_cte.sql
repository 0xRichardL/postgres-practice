/*
Index strategy 1: Basic multi-column index on (user_id, post_id)
 */
DROP INDEX IF EXISTS idx_post_views_user_counts;

CREATE INDEX IF NOT EXISTS idx_post_views_user_counts ON post_views(user_id, post_id);


/*
Index strategy 2: Optimized index with INCLUDE clause.
Only use `user_id` for BTREE key, since we only group by `user_id`, include `post_id` just for `count(post_id)`.
This make the index lighter (less key data), reduce table lookup for `post_id`.
 */
DROP INDEX IF EXISTS idx_post_views_user_counts_optimized;

CREATE INDEX IF NOT EXISTS idx_post_views_user_counts_optimized ON post_views(user_id) INCLUDE (post_id);


/*
CTE approach: Same like subquery approach, but better readability.
CTE gets top 5 active `user_id` from `post_views` first.
Then join with `users` table to get `username`.
 */
EXPLAIN ANALYZE WITH user_views AS (
  SELECT
    user_id,
    count(post_id) AS views
  FROM
    post_views
  GROUP BY
    user_id
  ORDER BY
    views DESC
  LIMIT 5
)
SELECT
  u.id,
  u.username,
  uv.views
FROM
  user_views uv
  JOIN users u ON u.id = uv.user_id
ORDER BY
  views DESC;

-- Index strategy 1
--                                                                                QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Nested Loop  (cost=117938.28..117979.58 rows=5 width=28) (actual time=558.483..562.224 rows=5 loops=1)
--    ->  Limit  (cost=117937.99..117938.01 rows=5 width=12) (actual time=558.317..561.946 rows=5 loops=1)
--          ->  Sort  (cost=117937.99..117940.49 rows=1000 width=12) (actual time=549.702..553.331 rows=5 loops=1)
--                Sort Key: (count(post_views.post_id)) DESC
--                Sort Method: top-N heapsort  Memory: 25kB
--                ->  Finalize GroupAggregate  (cost=117668.03..117921.38 rows=1000 width=12) (actual time=549.105..553.246 rows=1000 loops=1)
--                      Group Key: post_views.user_id
--                      ->  Gather Merge  (cost=117668.03..117901.38 rows=2000 width=12) (actual time=549.096..553.015 rows=3000 loops=1)
--                            Workers Planned: 2
--                            Workers Launched: 2
--                            ->  Sort  (cost=116668.01..116670.51 rows=1000 width=12) (actual time=526.028..526.061 rows=1000 loops=3)
--                                  Sort Key: post_views.user_id
--                                  Sort Method: quicksort  Memory: 64kB
--                                  Worker 0:  Sort Method: quicksort  Memory: 64kB
--                                  Worker 1:  Sort Method: quicksort  Memory: 64kB
--                                  ->  Partial HashAggregate  (cost=116608.18..116618.18 rows=1000 width=12) (actual time=525.778..525.852 rows=1000 loops=3)
--                                        Group Key: post_views.user_id
--                                        Batches: 1  Memory Usage: 129kB
--                                        Worker 0:  Batches: 1  Memory Usage: 129kB
--                                        Worker 1:  Batches: 1  Memory Usage: 129kB
--                                        ->  Parallel Seq Scan on post_views  (cost=0.00..95776.12 rows=4166412 width=8) (actual time=0.069..206.366 rows=3333130 loops=3)
--    ->  Index Scan using users_pkey on users u  (cost=0.29..8.30 rows=1 width=20) (actual time=0.041..0.041 rows=1 loops=5)
--          Index Cond: (id = post_views.user_id)
--  Planning Time: 1.578 ms
--  JIT:
--    Functions: 28
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 1.620 ms, Inlining 0.000 ms, Optimization 1.570 ms, Emission 18.678 ms, Total 21.867 ms
--  Execution Time: 601.032 ms
--
-- Index strategy 2
--                                                                                QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Nested Loop  (cost=117938.28..117979.58 rows=5 width=28) (actual time=517.132..521.005 rows=5 loops=1)
--    ->  Limit  (cost=117937.99..117938.01 rows=5 width=12) (actual time=517.037..520.804 rows=5 loops=1)
--          ->  Sort  (cost=117937.99..117940.49 rows=1000 width=12) (actual time=509.507..513.273 rows=5 loops=1)
--                Sort Key: (count(post_views.post_id)) DESC
--                Sort Method: top-N heapsort  Memory: 25kB
--                ->  Finalize GroupAggregate  (cost=117668.03..117921.38 rows=1000 width=12) (actual time=508.899..513.195 rows=1000 loops=1)
--                      Group Key: post_views.user_id
--                      ->  Gather Merge  (cost=117668.03..117901.38 rows=2000 width=12) (actual time=508.887..512.953 rows=3000 loops=1)
--                            Workers Planned: 2
--                            Workers Launched: 2
--                            ->  Sort  (cost=116668.01..116670.51 rows=1000 width=12) (actual time=487.673..487.724 rows=1000 loops=3)
--                                  Sort Key: post_views.user_id
--                                  Sort Method: quicksort  Memory: 64kB
--                                  Worker 0:  Sort Method: quicksort  Memory: 64kB
--                                  Worker 1:  Sort Method: quicksort  Memory: 64kB
--                                  ->  Partial HashAggregate  (cost=116608.18..116618.18 rows=1000 width=12) (actual time=487.455..487.527 rows=1000 loops=3)
--                                        Group Key: post_views.user_id
--                                        Batches: 1  Memory Usage: 129kB
--                                        Worker 0:  Batches: 1  Memory Usage: 129kB
--                                        Worker 1:  Batches: 1  Memory Usage: 129kB
--                                        ->  Parallel Seq Scan on post_views  (cost=0.00..95776.12 rows=4166412 width=8) (actual time=0.051..181.192 rows=3333130 loops=3)
--    ->  Index Scan using users_pkey on users u  (cost=0.29..8.30 rows=1 width=20) (actual time=0.038..0.038 rows=1 loops=5)
--          Index Cond: (id = post_views.user_id)
--  Planning Time: 1.478 ms
--  JIT:
--    Functions: 28
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 1.588 ms, Inlining 0.000 ms, Optimization 1.624 ms, Emission 17.067 ms, Total 20.279 ms
--  Execution Time: 558.451 ms
