/* 
 Content padding: 
 - root comments: no padding
 - child comments: prefixed with ' > ' and indented by 4 spaces per depth level.
 Path building:
 - each comment's path is built by concatenating its ancestors' IDs, zero-padded to 8 digits, separated by colons.
 - support lexicographical ordering of comments by path.
 Depth tracking:
 - depth starts at 0 for root comments and increments by 1 for each level of nesting.
 Safeguards:
 - limit recursion depth to 5 levels to prevent infinite loops.
 */
-- EXPLAIN ANALYZE
WITH RECURSIVE comment_thread AS (
  /*
   Anchor comments (root comments) 
   */
  SELECT
    c.id,
    c.parent_id,
    c.content,
    0 AS depth,
    LPAD(c.id::text, 8, '0') AS "path"
  FROM
    comments c
  WHERE
    parent_id IS NULL -- Anchor condition: only root comments, no parent.
    /* AND id = 481958 -- Filter the root comment here, best for load more. */
    AND post_id = 218595 -- Filter by post_id to limit scope.
  UNION ALL
  /*
   Recursive part: get child comments.
   Inner join `comments` rows to the previous level of `comment_thread`,
   each time getting one level deeper in the hierarchy,
   the `comment_thread` CTE size grows up each recursive loop.
   */
  SELECT
    c.id,
    c.parent_id,
    LPAD(' > ' || c.content, LENGTH(c.content) + 3 +(ct.depth + 1) * 4, ' ') AS content,
    ct.depth + 1 AS depth,
(ct.path || ':' || LPAD(c.id::text, 8, '0')) AS "path"
  FROM
    comments c
    INNER JOIN comment_thread ct ON c.parent_id = ct.id
)
SELECT
  *
FROM
  comment_thread
WHERE
  depth < 10 -- Limit the depth of recursion, safeguard against infinite loops.
ORDER BY
  "path";

