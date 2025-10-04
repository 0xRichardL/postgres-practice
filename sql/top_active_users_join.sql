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

