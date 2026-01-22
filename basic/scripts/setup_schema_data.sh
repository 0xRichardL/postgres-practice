## Init schemas
./psql.sh ./basic/sql/new_test_schema.sql
./psql.sh ./basic/sql/tables/users_table.sql
./psql.sh ./basic/sql/tables/posts_table.sql
./psql.sh ./basic/sql/tables/post_views_table.sql
./psql.sh ./basic/sql/tables/comments_table.sql

npx tsx ./basic/scripts/gen_user_seed.ts
npx tsx ./basic/scripts/gen_post_seed.ts
npx tsx ./basic/scripts/gen_post_view_seed.ts
npx tsx ./basic/scripts/gen_comment_seed.ts

## Seed data
./psql.sh ./basic/sql/import_users.cmd
./psql.sh ./basic/sql/import_posts.cmd
./psql.sh ./basic/sql/import_post_views.cmd
./psql.sh ./basic/sql/import_comments.cmd