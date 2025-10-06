DROP TABLE IF EXISTS posts CASCADE;

CREATE TABLE posts(
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  metadata JSONB
);

CREATE INDEX IF NOT EXISTS idx_posts_metadata ON posts USING GIN(metadata);

CREATE INDEX IF NOT EXISTS idx_posts_metadata_featured ON posts(((metadata ->> 'featured')::BOOL));

CREATE INDEX IF NOT EXISTS idx_posts_metadata_read_time ON posts(((metadata ->> 'read_time')::INT));

