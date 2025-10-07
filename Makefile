# Database connection settings
DB_NAME ?= postgres
DB_USER ?= postgres
DB_HOST ?= localhost
DB_PORT ?= 5432
export PGPASSWORD=postgres

# PSQL command with common flags
PSQL = psql -U $(DB_USER) -w -h $(DB_HOST) -p $(DB_PORT) -d $(DB_NAME)

# Add this rule to handle arbitrary targets
.PHONY: up down psql

up:
	docker compose up -d

down:
	docker compose down --volumes --remove-orphans

psql:
	@$(PSQL) -f $(filter-out $@,$(MAKECMDGOALS))