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

--                                                                              QUERY PLAN
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Nested Loop  (cost=12988.09..13025.36 rows=5 width=25) (actual time=104.885..107.496 rows=5 loops=1)
--    ->  Limit  (cost=12987.81..12987.83 rows=5 width=12) (actual time=104.742..107.284 rows=5 loops=1)
--          ->  Sort  (cost=12987.81..12990.31 rows=1000 width=12) (actual time=104.740..107.282 rows=5 loops=1)
--                Sort Key: (count(post_views.post_id)) DESC
--                Sort Method: top-N heapsort  Memory: 25kB
--                ->  Finalize GroupAggregate  (cost=12717.85..12971.20 rows=1000 width=12) (actual time=104.076..107.187 rows=1000 loops=1)
--                      Group Key: post_views.user_id
--                      ->  Gather Merge  (cost=12717.85..12951.20 rows=2000 width=12) (actual time=104.071..106.908 rows=3000 loops=1)
--                            Workers Planned: 2
--                            Workers Launched: 2
--                            ->  Sort  (cost=11717.83..11720.33 rows=1000 width=12) (actual time=97.878..97.913 rows=1000 loops=3)
--                                  Sort Key: post_views.user_id
--                                  Sort Method: quicksort  Memory: 64kB
--                                  Worker 0:  Sort Method: quicksort  Memory: 64kB
--                                  Worker 1:  Sort Method: quicksort  Memory: 64kB
--                                  ->  Partial HashAggregate  (cost=11658.00..11668.00 rows=1000 width=12) (actual time=97.558..97.664 rows=1000 loops=3)
--                                        Group Key: post_views.user_id
--                                        Batches: 1  Memory Usage: 129kB
--                                        Worker 0:  Batches: 1  Memory Usage: 129kB
--                                        Worker 1:  Batches: 1  Memory Usage: 129kB
--                                        ->  Parallel Seq Scan on post_views  (cost=0.00..9574.67 rows=416667 width=8) (actual time=0.085..48.250 rows=333333 loops=3)
--    ->  Index Scan using users_pkey on users u  (cost=0.28..7.49 rows=1 width=17) (actual time=0.040..0.040 rows=1 loops=5)
--          Index Cond: (id = post_views.user_id)
--  Planning Time: 1.902 ms
--  Execution Time: 107.872 ms
-- (25 rows)
