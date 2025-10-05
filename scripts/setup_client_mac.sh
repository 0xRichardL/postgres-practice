#!/bin/bash
# Install PostgreSQL client libraries on macOS using Homebrew.
brew install libpq
# Link the libraries to make them accessible. Expose the psql cmd.
brew link --force libpq