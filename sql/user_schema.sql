-- Create an enum.
CREATE TYPE user_status AS ENUM(
  'ONLINE',
  'OFFLINE'
);

-- Create users table with basic column types.
CREATE TABLE IF NOT EXISTS users(
  id SERIAL PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  "status" user_status,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Add email column to users table.
ALTER TABLE users
  ADD COLUMN email TEXT;

-- Add an unique constraint for email column.
ALTER TABLE users
  ADD CONSTRAINT email_unique UNIQUE (email);

