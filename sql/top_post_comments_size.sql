SELECT
  post_id,
  COUNT(*) AS "size"
FROM
  comments
GROUP BY
  post_id
ORDER BY
  "size" DESC
LIMIT 10;

