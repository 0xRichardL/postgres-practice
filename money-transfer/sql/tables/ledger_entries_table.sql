CREATE TYPE ledger_entry_type AS ENUM(
  'DEBIT',
  'CREDIT'
);

CREATE TABLE IF NOT EXISTS ledger_entries(
  ledger_id UUID PRIMARY KEY,
  account_id UUID NOT NULL,
  -- money
  amount BIGINT NOT NULL,
  currency CHAR(3) NOT NULL,
  global_tx_id UUID NOT NULL,
  -- classification
  entry_type ledger_entry_type NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- Constraints:
  CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT uk_global_tx_entry_type UNIQUE (global_tx_id, entry_type),
  CONSTRAINT chk_amount_positive CHECK (amount > 0)
);

-- For balance reconciliation
CREATE INDEX IF NOT EXISTS idx_ledger_account_currency ON ledger_entries(account_id, currency);

-- For audit queries
CREATE INDEX IF NOT EXISTS idx_ledger_global_tx_id ON ledger_entries(global_tx_id);

CREATE INDEX IF NOT EXISTS idx_ledger_created_at ON ledger_entries(created_at DESC);

