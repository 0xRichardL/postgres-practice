CREATE TABLE IF NOT EXISTS balances(
  account_id UUID NOT NULL,
  currency CHAR(3) NOT NULL,
  balance BIGINT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP DEFAULT NOW(),
  -- Constraints:
  CONSTRAINT pk_balances PRIMARY KEY (account_id, currency)
);

CREATE INDEX IF NOT EXISTS idx_balances_account_id ON balances(account_id);

