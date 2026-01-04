CREATE TABLE IF NOT EXISTS ledger_entries(
  ledger_id UUID PRIMARY KEY,
  account_id UUID NOT NULL,
  -- money
  amount BIGINT NOT NULL,
  currency CHAR(3) NOT NULL,
  global_tx_id UUID NOT NULL,
  -- classification
  entry_type ENUM('DEBIT', 'CREDIT') NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  -- Constraints:
  CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT uk_global_tx_entry_type UNIQUE (global_tx_id, entry_type)
);

