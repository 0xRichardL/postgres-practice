## Init schemas
make psql ./sql/new_test_schema.sql
make psql ./sql/tables/users_table.sql
make psql ./sql/tables/posts_table.sql
make psql ./sql/tables/post_views_table.sql

npx tsx ./scripts/gen_user_seed.ts
npx tsx ./scripts/gen_post_seed.ts
npx tsx ./scripts/gen_post_view_seed.ts

## Seed data
make psql ./sql/import_users.cmd
make psql ./sql/import_posts.cmd
make psql ./sql/import_post_views.cmd