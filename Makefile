# Makefile for miss.nvim plugin

.PHONY: test test-verbose test-single clean install-deps help

# Default target
all: test

# Run all tests
test:
	@echo "Running tests for miss.nvim..."
	@nvim --headless -c "lua require('tests.plenary.run')" -c "quit"

# Run tests with verbose output
test-verbose:
	@echo "Running tests with verbose output..."
	@nvim --headless -c "lua require('plenary.test_harness').test_directory('tests/plenary', { verbose = true })" -c "quit"

# Run a single test file
test-single:
	@echo "Running single test file..."
	@nvim --headless -c "lua require('tests.plenary.test_miss')" -c "quit"

# Install test dependencies
install-deps:
	@echo "Installing test dependencies..."
	@mkdir -p ~/.local/share/nvim/site/pack/plenary/start
	@if [ ! -d ~/.local/share/nvim/site/pack/plenary/start/plenary.nvim ]; then \
		git clone https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/site/pack/plenary/start/plenary.nvim; \
	else \
		echo "plenary.nvim already installed"; \
	fi

# Clean up test artifacts
clean:
	@echo "Cleaning up..."
	@find . -name "*.swp" -delete
	@find . -name "*.swo" -delete
	@find . -name "*~" -delete

# Development workflow: install deps and run tests
dev: install-deps test

# Show help
help:
	@echo "Available targets:"
	@echo "  test          - Run all tests"
	@echo "  test-verbose  - Run tests with verbose output"
	@echo "  test-single   - Run single test file"
	@echo "  install-deps  - Install test dependencies"
	@echo "  clean         - Clean up temporary files"
	@echo "  dev           - Install deps and run tests"
	@echo "  help          - Show this help message"

# CI/CD target for GitHub Actions
ci: install-deps test
