# Money Transfer

This project demonstrates a strong consistency model for transferring money between bank accounts using a distributed system. It ensures that all operations are atomic, consistent, isolated, and durable (ACID properties) even in the presence of failures.

## Features

### 1. Ledger model

This project uses ledger records to persist account balance changes. Leverages append-only fashion to ensure durability and traceability of all transactions.

### 2. Advisory locks

Row lock on balances table will cause deadlocks, peak CPU, memory usage in high-contention environments.

Advisory lock based on `account_id` jumps in to improve concurrency power, lower resource consumption while maintaining strong consistency.

> **Lock strategy:**\
> Only one writer for a given pair of debit + credit accounts at a time.

### 3. Outbox pattern

To ensure reliability while maintaining strong consistency, the outbox pattern is used to decouple the money transfer operation to the next steps.

**Key concepts:**

- All changes are recorded in an outbox table within the same transaction as the money transfer.
- A separate process reads from the outbox table and processes the messages (e.g., sending notifications, updating external systems).
- Provides failure tolerance and ensures that messages are eventually delivered.

### 4. Idempotency

Idempotency is crucial in distributed systems to handle retries without causing duplicate effects.
This project implements client-generated unique request IDs to create idempotent transactions and its `tx_id` then use that as a global unique identifier.
