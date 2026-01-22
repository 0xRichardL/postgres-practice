CREATE TABLE IF NOT EXISTS post_views(
  -- Use inline style foreign key for simplicity.
  post_id SERIAL NOT NULL REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE,
  user_id SERIAL NOT NULL,
  viewed_at TIMESTAMP DEFAULT NOW(),
  -- Multi-fields primary key.
  CONSTRAINT pk_post_views PRIMARY KEY (post_id, user_id),
  -- Use constraint style for clearer in big schemas.
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

