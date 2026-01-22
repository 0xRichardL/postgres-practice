-- High Contention Accounts (Hot Wallet, Big Merchant)
-- Big Merchant 1: frequently used, high balance, multi-currency
INSERT INTO accounts(account_id)
  VALUES ('00000000-0000-0000-0000-000000000001');

INSERT INTO balances(account_id, balance, currency)
VALUES
  ('00000000-0000-0000-0000-000000000001', 100000000, 'USD'),
('00000000-0000-0000-0000-000000000001', 50000000, 'EUR');

-- Big Merchant 2: frequently used, high balance, multi-currency
INSERT INTO accounts(account_id)
  VALUES ('00000000-0000-0000-0000-000000000002');

INSERT INTO balances(account_id, balance, currency)
VALUES
  ('00000000-0000-0000-0000-000000000002', 80000000, 'USD'),
('00000000-0000-0000-0000-000000000002', 30000000, 'EUR');

INSERT INTO accounts(account_id)
  VALUES ('00000000-0000-0000-0000-000000000101');

INSERT INTO balances(account_id, balance, currency)
VALUES
  ('00000000-0000-0000-0000-000000000101', 100, 'USD'),
('00000000-0000-0000-0000-000000000101', 50, 'EUR');

-- Low Contention Accounts (Normal Users)
--
-- Normal User 2: medium balance, multi-currency
INSERT INTO accounts(account_id)
  VALUES ('00000000-0000-0000-0000-000000000102');

INSERT INTO balances(account_id, balance, currency)
VALUES
  ('00000000-0000-0000-0000-000000000102', 5000, 'USD'),
('00000000-0000-0000-0000-000000000102', 2000, 'EUR');

-- Normal User 3: big balance, multi-currency
INSERT INTO accounts(account_id)
  VALUES ('00000000-0000-0000-0000-000000000103');

INSERT INTO balances(account_id, balance, currency)
VALUES
  ('00000000-0000-0000-0000-000000000103', 1000000, 'USD'),
('00000000-0000-0000-0000-000000000103', 500000, 'EUR');

-- Normal User 4: zero balance, multi-currency
INSERT INTO accounts(account_id)
  VALUES ('00000000-0000-0000-0000-000000000104');

INSERT INTO balances(account_id, balance, currency)
VALUES
  ('00000000-0000-0000-0000-000000000104', 0, 'USD'),
('00000000-0000-0000-0000-000000000104', 0, 'EUR');

