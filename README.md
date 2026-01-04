# Postgres Practice

PostgreSQL practice projects exploring performance optimization, advanced queries, and high-concurrency scenarios.

**Prerequisites:** Docker, Node.js, Go, pnpm

## Basic: Blog Platform

**Schema:** Users, posts, comments, post_views

**Data Scale:** 1k users, 500k posts

Demonstrates PostgreSQL query optimization techniques and full-text search:

- Query patterns: CTEs, joins, subqueries, window functions, materialized views
- Full-text search with GIN indexes
- CSV data generation and bulk imports

**Key Files:**

- `top_active_users_*.sql` - Analytics queries (5 different approaches)
- `latest_featured_posts*.sql` - Full-text search with/without indexing
- `get_post_threads.sql` - Threaded comment retrieval

## Money Transfer: High-Contention Testing

**Schema:** Balances, ledger entries

**Data Scale:** 1k users, 500k posts

Simulates high-concurrency financial transactions:

- Ledger-based double-entry accounting
- Go-based load testing
- Transaction isolation and locking strategies
