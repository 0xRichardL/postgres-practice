CREATE TABLE IF NOT EXISTS balances(
  -- Identity:
  account_id UUID NOT NULL,
  -- Money:
  balance BIGINT NOT NULL DEFAULT 0,
  currency CHAR(3) NOT NULL,
  -- Timestamps:
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Constraints:
  CONSTRAINT fk_account_balance FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT pk_balances PRIMARY KEY (account_id, currency),
  CONSTRAINT chk_balance_positive CHECK (balance >= 0)
);

CREATE INDEX IF NOT EXISTS idx_balances_account_id ON balances(account_id);

