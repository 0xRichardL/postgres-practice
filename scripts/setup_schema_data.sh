## Init schemas
make pqsl ./sql/user_schema.sql
make psql ./sql/post_schema.sql
make psql ./sql/post_view_schema.sql
## Seed data
make psql ./sql/seed_users.cmd
make psql ./sql/seed_posts.cmd
make psql ./sql/seed_post_views.cmd