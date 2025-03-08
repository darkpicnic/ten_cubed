# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/lib/ten_cubed/version.rb"
  add_group "Models", "lib/ten_cubed"
  add_group "Concerns", "lib/ten_cubed/models/concerns"
  add_group "Generators", "lib/generators"
end

# First, load the dependencies
require "active_record"
require "active_support/all"
require "rails"

# Configure database before requiring ten_cubed
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  host: ENV.fetch("POSTGRES_HOST", "localhost"),
  username: ENV.fetch("POSTGRES_USER", "postgres"),
  password: ENV.fetch("POSTGRES_PASSWORD", "postgres"),
  database: ENV.fetch("POSTGRES_DB", "ten_cubed_test")
)

# Create tables for testing
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.integer :max_degree, default: 3
    t.timestamps
  end

  create_table :connections, force: true do |t|
    t.references :user
    t.references :target
    t.timestamps
  end
end

# Define User class for testing
class User < ActiveRecord::Base
  # User model for testing
end

# Now load the gem
require "ten_cubed"

# Initialize configuration with default settings
TenCubed.configure do |config|
  config.max_direct_connections = 10
  config.max_network_depth = 3
  config.connection_table_name = :connections
end

# Load other test dependencies
require "database_cleaner/active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Database cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
