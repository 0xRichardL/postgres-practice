/*
Index strategy 1: Basic multi-column index on (user_id, post_id)
 */
DROP INDEX IF EXISTS idx_post_views_user_counts;

-- CREATE INDEX IF NOT EXISTS idx_post_views_user_counts ON post_views(user_id, post_id);
/*
Index strategy 2: Optimized index with INCLUDE clause.
Only use `user_id` for BTREE key, since we only group by `user_id`, include `post_id` just for `count(post_id)`.
This make the index lighter (less key data), reduce table lookup for `post_id`.
 */
DROP INDEX IF EXISTS idx_post_views_user_counts_optimized;

CREATE INDEX IF NOT EXISTS idx_post_views_user_counts_optimized ON post_views(user_id) INCLUDE (post_id);


/*
Subquery approach: Get top 5 active `user_id` from `post_views` first.
Then join with `users` table to get `username`.
 */
EXPLAIN ANALYZE
SELECT
  u.id,
  u.username,
  tv.views
FROM (
  SELECT
    user_id,
    count(post_id) AS views
  FROM
    post_views
  GROUP BY
    user_id
  ORDER BY
    views DESC
  LIMIT 5) AS tv
  JOIN users u ON tv.user_id = u.id;

-- Index strategy 1
--                                                                                QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Nested Loop  (cost=117938.28..117979.58 rows=5 width=28) (actual time=529.475..533.075 rows=5 loops=1)
--    ->  Limit  (cost=117937.99..117938.01 rows=5 width=12) (actual time=529.382..532.876 rows=5 loops=1)
--          ->  Sort  (cost=117937.99..117940.49 rows=1000 width=12) (actual time=522.293..525.786 rows=5 loops=1)
--                Sort Key: (count(post_views.post_id)) DESC
--                Sort Method: top-N heapsort  Memory: 25kB
--                ->  Finalize GroupAggregate  (cost=117668.03..117921.38 rows=1000 width=12) (actual time=521.604..525.687 rows=1000 loops=1)
--                      Group Key: post_views.user_id
--                      ->  Gather Merge  (cost=117668.03..117901.38 rows=2000 width=12) (actual time=521.595..525.370 rows=3000 loops=1)
--                            Workers Planned: 2
--                            Workers Launched: 2
--                            ->  Sort  (cost=116668.01..116670.51 rows=1000 width=12) (actual time=500.862..500.897 rows=1000 loops=3)
--                                  Sort Key: post_views.user_id
--                                  Sort Method: quicksort  Memory: 64kB
--                                  Worker 0:  Sort Method: quicksort  Memory: 64kB
--                                  Worker 1:  Sort Method: quicksort  Memory: 64kB
--                                  ->  Partial HashAggregate  (cost=116608.18..116618.18 rows=1000 width=12) (actual time=500.621..500.697 rows=1000 loops=3)
--                                        Group Key: post_views.user_id
--                                        Batches: 1  Memory Usage: 129kB
--                                        Worker 0:  Batches: 1  Memory Usage: 129kB
--                                        Worker 1:  Batches: 1  Memory Usage: 129kB
--                                        ->  Parallel Seq Scan on post_views  (cost=0.00..95776.12 rows=4166412 width=8) (actual time=0.049..189.200 rows=3333130 loops=3)
--    ->  Index Scan using users_pkey on users u  (cost=0.29..8.30 rows=1 width=20) (actual time=0.037..0.037 rows=1 loops=5)
--          Index Cond: (id = post_views.user_id)
--  Planning Time: 1.333 ms
--  JIT:
--    Functions: 28
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 1.433 ms, Inlining 0.000 ms, Optimization 1.503 ms, Emission 15.523 ms, Total 18.459 ms
--  Execution Time: 568.585 ms
--
-- Index strategy 1
--                                                                                QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Nested Loop  (cost=117938.28..117979.58 rows=5 width=28) (actual time=523.076..526.364 rows=5 loops=1)
--    ->  Limit  (cost=117937.99..117938.01 rows=5 width=12) (actual time=523.005..526.218 rows=5 loops=1)
--          ->  Sort  (cost=117937.99..117940.49 rows=1000 width=12) (actual time=515.728..518.940 rows=5 loops=1)
--                Sort Key: (count(post_views.post_id)) DESC
--                Sort Method: top-N heapsort  Memory: 25kB
--                ->  Finalize GroupAggregate  (cost=117668.03..117921.38 rows=1000 width=12) (actual time=515.080..518.808 rows=1000 loops=1)
--                      Group Key: post_views.user_id
--                      ->  Gather Merge  (cost=117668.03..117901.38 rows=2000 width=12) (actual time=515.070..518.573 rows=3000 loops=1)
--                            Workers Planned: 2
--                            Workers Launched: 2
--                            ->  Sort  (cost=116668.01..116670.51 rows=1000 width=12) (actual time=496.714..496.748 rows=1000 loops=3)
--                                  Sort Key: post_views.user_id
--                                  Sort Method: quicksort  Memory: 64kB
--                                  Worker 0:  Sort Method: quicksort  Memory: 64kB
--                                  Worker 1:  Sort Method: quicksort  Memory: 64kB
--                                  ->  Partial HashAggregate  (cost=116608.18..116618.18 rows=1000 width=12) (actual time=496.532..496.598 rows=1000 loops=3)
--                                        Group Key: post_views.user_id
--                                        Batches: 1  Memory Usage: 129kB
--                                        Worker 0:  Batches: 1  Memory Usage: 129kB
--                                        Worker 1:  Batches: 1  Memory Usage: 129kB
--                                        ->  Parallel Seq Scan on post_views  (cost=0.00..95776.12 rows=4166412 width=8) (actual time=0.038..187.705 rows=3333130 loops=3)
--    ->  Index Scan using users_pkey on users u  (cost=0.29..8.30 rows=1 width=20) (actual time=0.027..0.027 rows=1 loops=5)
--          Index Cond: (id = post_views.user_id)
--  Planning Time: 0.916 ms
--  JIT:
--    Functions: 28
--    Options: Inlining false, Optimization false, Expressions true, Deforming true
--    Timing: Generation 1.042 ms, Inlining 0.000 ms, Optimization 1.065 ms, Emission 14.996 ms, Total 17.104 ms
--  Execution Time: 544.815 ms
