# Testing the TenCubed Gem with PostgreSQL

## Prerequisites

The TenCubed gem requires PostgreSQL for testing. You must have PostgreSQL installed and running on your system.

## Configuration

The tests are configured to connect to PostgreSQL using the following environment variables:

- `POSTGRES_HOST`: PostgreSQL server hostname (default: `localhost`)
- `POSTGRES_USER`: PostgreSQL username (default: `postgres`)
- `POSTGRES_PASSWORD`: PostgreSQL password (default: `postgres`)
- `POSTGRES_DB`: PostgreSQL database name (default: `ten_cubed_test`)

You can set these variables before running the tests:

```bash
export POSTGRES_HOST=localhost
export POSTGRES_USER=your_username
export POSTGRES_PASSWORD=your_password
export POSTGRES_DB=ten_cubed_test
```

Alternatively, you can create a PostgreSQL user and database using the default values:

```sql
CREATE USER postgres WITH PASSWORD 'postgres';
CREATE DATABASE ten_cubed_test OWNER postgres;
```

## Running the Tests

To run the tests, simply execute:

```bash
bundle exec rspec
```

## Coverage Reports

Test coverage reports are generated using SimpleCov. After running the tests, you can find the coverage report at `coverage/index.html`. 