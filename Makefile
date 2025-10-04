.PHONY: up run

up:
	docker compose up -d

down:
	docker compose down --volumes --remove-orphans

psql:
	PGPASSWORD=postgres psql -h localhost -U postgres -w -d postgres -f $(word 2,$(MAKECMDGOALS))