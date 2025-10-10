# Postgres practice

**Project:** Blog Platform Database with Analytics & Search

**Duration:** 4 Weeks

**Owner:** You (Developer)

**Goal:** Rewarm PostgreSQL skills, moving from rusty intermediate to fluent advanced by implementing a real-world database with advanced features.

## 1. **Overview**

We will build a **Blog Platform database** that supports users, posts, comments, and analytics. The system must cover schema design, indexing, performance optimization, advanced SQL features (views, functions, partitioning), and operational skills (backup/restore, security).

The final deliverable will be:

- A working database schema with sample data.
- Queries, views, functions, and indexes demonstrating advanced Postgres use.
- Documentation of design decisions and performance benchmarks.

## 2. **Objectives**

1. Relearn and practice **core SQL** (joins, CTEs, JSONB).
2. Apply **indexing and performance tuning** on large datasets.
3. Implement **advanced Postgres features**: window functions, materialized views, triggers, partitioning.
4. Practice **operations**: backup/restore, row-level security, and full-text search.
5. Deliver a **mini real-world project** that can be showcased as part of portfolio.

## 3. **Scope**

### In-Scope

- Core schema: `users`, `posts`, `comments`, `tags`.
- Extended features: JSONB metadata, full-text search, partitioned sales/logs table.
- Advanced queries: leaderboards, trending posts, analytics.
- Performance benchmarks with EXPLAIN ANALYZE.
- Ops exercises: backup/restore, row-level security.

### Out-of-Scope

- Building a full application (API/UI).
- Scaling to production environments (clustering, replication).

## 4. **Functional Requirements (By Week)**

### **Week 1 – Schema & Core Queries**

- [x] Design schema with constraints (PK, FK, CHECK, UNIQUE).
  - [x] `users`
  - [x] `posts`
  - [x] `post_views`
  - [ ] `comments`
- [x] Add JSONB metadata column in `posts` (e.g., `{"read_time": 5, "featured": true}`).
- Write queries:
  - [x] Posts with JSONB filter (e.g., posts with `featured = true`).
  - [x] Top 5 most active users, counted by views.
  - [x] Recursive CTE: build a comment thread tree.
    - [ ] Optimize query by indexes.

### **Week 2 – Indexing & Performance**

- [x] Insert ~500k rows into `posts`.
- [x] Insert ~1M rows into `post_views`.
- [x] Insert ~500k rows into `comments`.
- [ ] Benchmark queries with `EXPLAIN ANALYZE`.
  - [x] Basics.
  - [ ] Fully understand all metrics.
- [x] Add B-tree, GIN, and BRIN indexes. Compare performance.
- [x] Document query improvement with indexes.

### **Week 3 – Advanced SQL Features**

- [ ] Implement window functions: rank posts by views per month.
- [ ] Create a materialized view: “Most active users this week.”
- [ ] Write a trigger: log edits in an `audit_log` table.
- [ ] Partition a `page_views` table by month (range partition).

### **Week 4 – Ops & Security**

- [x] Use `psql` client with `libpq` on terminal only, not depending on tools.
- [ ] Implement row-level security:
  - [ ] Users can edit only their own posts.
- [ ] Build full-text search on `posts.content` with GIN + `to_tsvector`.
- [ ] Backup the database with `pg_dump` and restore it.
- [ ] Deliver final **documentation**: schema diagram, queries, performance benchmarks.

## 5. **Non-Functional Requirements**

- [ ] Must run on **Postgres 16+** (local via Docker or pkg).
- [ ] Use **SQL scripts** for schema, seed data, and queries.
- [ ] Documentation in Markdown: design choices, benchmark results, lessons learned.

## 6. **Milestones**

- **End of Week 1:** Core schema + basic queries.
- **End of Week 2:** Indexing + performance benchmarks.
- **End of Week 3:** Advanced SQL features working.
- **End of Week 4:** Ops features complete + final documentation.
