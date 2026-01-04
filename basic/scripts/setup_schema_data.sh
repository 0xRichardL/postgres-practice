## Init schemas
make psql ./basic/sql/new_test_schema.sql
make psql ./basic/sql/tables/users_table.sql
make psql ./basic/sql/tables/posts_table.sql
make psql ./basic/sql/tables/post_views_table.sql
make psql ./basic/sql/tables/comments_table.sql

npx tsx ./basic/scripts/gen_user_seed.ts
npx tsx ./basic/scripts/gen_post_seed.ts
npx tsx ./basic/scripts/gen_post_view_seed.ts
npx tsx ./basic/scripts/gen_comment_seed.ts

## Seed data
make psql ./basic/sql/import_users.cmd
make psql ./basic/sql/import_posts.cmd
make psql ./basic/sql/import_post_views.cmd
make psql ./basic/sql/import_comments.cmd