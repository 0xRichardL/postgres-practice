EXPLAIN ANALYZE
SELECT
  u.id,
  u.username,
  count(pv.post_id) AS views
FROM
  post_views pv
  JOIN users u ON pv.user_id = u.id
GROUP BY
  u.id,
  u.username
ORDER BY
  views DESC
LIMIT 5;

--                                                                             QUERY PLAN
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=14314.29..14314.30 rows=5 width=25) (actual time=122.180..124.554 rows=5 loops=1)
--    ->  Sort  (cost=14314.29..14319.29 rows=2000 width=25) (actual time=122.178..124.552 rows=5 loops=1)
--          Sort Key: (count(pv.post_id)) DESC
--          Sort Method: top-N heapsort  Memory: 25kB
--          ->  Finalize HashAggregate  (cost=14261.07..14281.07 rows=2000 width=25) (actual time=121.986..124.444 rows=1000 loops=1)
--                Group Key: u.id
--                Batches: 1  Memory Usage: 241kB
--                ->  Gather  (cost=13821.07..14241.07 rows=4000 width=25) (actual time=121.370..123.955 rows=3000 loops=1)
--                      Workers Planned: 2
--                      Workers Launched: 2
--                      ->  Partial HashAggregate  (cost=12821.07..12841.07 rows=2000 width=25) (actual time=112.515..112.618 rows=1000 loops=3)
--                            Group Key: u.id
--                            Batches: 1  Memory Usage: 241kB
--                            Worker 0:  Batches: 1  Memory Usage: 241kB
--                            Worker 1:  Batches: 1  Memory Usage: 241kB
--                            ->  Hash Join  (cost=67.00..10737.73 rows=416667 width=21) (actual time=1.196..79.661 rows=333333 loops=3)
--                                  Hash Cond: (pv.user_id = u.id)
--                                  ->  Parallel Seq Scan on post_views pv  (cost=0.00..9574.67 rows=416667 width=8) (actual time=0.107..28.576 rows=333333 loops=3)
--                                  ->  Hash  (cost=42.00..42.00 rows=2000 width=17) (actual time=1.059..1.059 rows=2000 loops=3)
--                                        Buckets: 2048  Batches: 1  Memory Usage: 113kB
--                                        ->  Seq Scan on users u  (cost=0.00..42.00 rows=2000 width=17) (actual time=0.055..0.573 rows=2000 loops=3)
--  Planning Time: 2.263 ms
--  Execution Time: 124.948 ms
-- (23 rows)
