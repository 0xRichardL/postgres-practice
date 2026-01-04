EXPLAIN ANALYZE
SELECT
  id,
  username,
  views
FROM (
  SELECT
    u.id,
    u.username,
    COUNT(pv.post_id) AS views,
    DENSE_RANK() OVER (ORDER BY COUNT(pv.post_id) DESC) AS rank
  FROM
    users u
  LEFT JOIN post_views pv ON u.id = pv.user_id
GROUP BY
  u.id,
  u.username) ranked
WHERE
  rank <= 5;

--                                                                       QUERY PLAN
-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--  Subquery Scan on ranked  (cost=23235.22..23290.22 rows=2000 width=25) (actual time=263.504..263.508 rows=5 loops=1)
--    ->  WindowAgg  (cost=23235.22..23270.22 rows=2000 width=33) (actual time=263.503..263.506 rows=5 loops=1)
--          Run Condition: (dense_rank() OVER (?) <= 5)
--          ->  Sort  (cost=23235.22..23240.22 rows=2000 width=25) (actual time=263.498..263.500 rows=6 loops=1)
--                Sort Key: (count(pv.post_id)) DESC
--                Sort Method: quicksort  Memory: 160kB
--                ->  HashAggregate  (cost=23105.56..23125.56 rows=2000 width=25) (actual time=263.110..263.258 rows=2000 loops=1)
--                      Group Key: u.id
--                      Batches: 1  Memory Usage: 369kB
--                      ->  Hash Right Join  (cost=67.00..18105.56 rows=1000000 width=21) (actual time=1.103..181.034 rows=1001000 loops=1)
--                            Hash Cond: (pv.user_id = u.id)
--                            ->  Seq Scan on post_views pv  (cost=0.00..15408.00 rows=1000000 width=8) (actual time=0.171..54.434 rows=1000000 loops=1)
--                            ->  Hash  (cost=42.00..42.00 rows=2000 width=17) (actual time=0.902..0.903 rows=2000 loops=1)
--                                  Buckets: 2048  Batches: 1  Memory Usage: 113kB
--                                  ->  Seq Scan on users u  (cost=0.00..42.00 rows=2000 width=17) (actual time=0.045..0.463 rows=2000 loops=1)
--  Planning Time: 1.444 ms
--  Execution Time: 263.840 ms
-- (17 rows)
