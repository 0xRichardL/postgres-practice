CREATE TYPE outbox_aggregated_type AS ENUM(
  'LEDGER',
  'BALANCE',
  'TRANSACTION'
);

CREATE TYPE outbox_event_type AS ENUM(
  'debit.committed',
  'credit.committed'
);

CREATE TYPE outbox_status AS ENUM(
  'PENDING',
  'SENT',
  'FAILED'
);

CREATE TABLE IF NOT EXISTS outbox_messages(
  event_id UUID PRIMARY KEY,
  aggregated_type outbox_aggregated_type NOT NULL,
  aggregated_id UUID NOT NULL,
  -- Event data:
  event_type outbox_event_type NOT NULL,
  payload JSON NOT NULL,
  -- Processing status:
  status outbox_status NOT NULL DEFAULT 'PENDING',
  retry_count INT NOT NULL DEFAULT 0,
  -- Timestamps:
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  published_at TIMESTAMPTZ,
  -- Constraints:
  CONSTRAINT uk_event_type_aggregated_id UNIQUE (event_type, aggregated_id)
);

-- For outbox pulling:
CREATE INDEX IF NOT EXISTS idx_status_created_at ON outbox_messages(status, created_at)
WHERE
  status = 'PENDING';

-- For retrying failed messages:
CREATE INDEX IF NOT EXISTS idx_failed_retry ON outbox_messages(status, retry_count, created_at)
WHERE
  status = 'FAILED';

