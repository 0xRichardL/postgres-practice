package shared

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/lib/pq"
)

type DB struct {
	*sql.DB
}

// NewPostgres creates a new PostgreSQL connection for testing
func NewPostgres() *DB {

	connStr := fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		"localhost",
		5432,
		"postgres",
		"postgres",
		"postgres",
	)

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Configure connection pool
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(5)
	db.SetConnMaxLifetime(5 * time.Minute)

	// Verify connection
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := db.PingContext(ctx); err != nil {
		log.Fatalf("Failed to ping database: %v", err)
	}

	return &DB{DB: db}
}

// ExecFile executes a SQL file
func (p *DB) ExecFile(filepath string) {

	content, err := os.ReadFile(filepath)
	if err != nil {
		log.Fatalf("Failed to read SQL file %s: %v", filepath, err)
	}

	_, err = p.Exec(string(content))
	if err != nil {
		log.Fatalf("Failed to execute SQL file %s: %v", filepath, err)
	}
}
