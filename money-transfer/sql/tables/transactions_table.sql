CREATE TYPE transaction_status AS ENUM(
  'INIT',
  'PROCESSING',
  'COMPLETED',
  'FAILED'
);

CREATE TABLE IF NOT EXISTS transactions(
  -- Identity:
  tx_id UUID PRIMARY KEY,
  idempotency_key UUID NOT NULL UNIQUE,
  -- Parties:
  client_id UUID NOT NULL,
  from_user_id UUID NOT NULL,
  to_user_id UUID NOT NULL,
  -- Money:
  amount BIGINT NOT NULL,
  currency CHAR(3) NOT NULL,
  -- State:
  status transaction_status NOT NULL DEFAULT 'INIT',
  -- Timestamps:
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Constraints:
  CONSTRAINT chk_amount_positive CHECK (amount > 0)
);

CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(status);

CREATE INDEX IF NOT EXISTS idx_transactions_from_user ON transactions(from_user_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transactions_to_user ON transactions(to_user_id, created_at DESC);

