.PHONY: up run

up:
	docker compose up -d

run:
	PGPASSWORD=postgres psql -h localhost -U postgres -w -d postgres -f $(word 2,$(MAKECMDGOALS))