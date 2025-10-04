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

