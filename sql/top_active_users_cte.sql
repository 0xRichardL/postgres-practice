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
  views DESC
