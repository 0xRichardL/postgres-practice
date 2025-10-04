\COPY post_view(post_id, user_id, viewed_at) FROM './seeds/users_1k.csv' DELIMITER ',' CSV HEADER;

