# frozen_string_literal: true

# Created by AI

TenCubed.configure do |config|
  # Maximum number of direct connections a user can have
  # Default: 10
  # config.max_direct_connections = 10

  # Maximum network depth for querying connections
  # Default: 3
  # config.max_network_depth = 3

  # Table name for connections
  # Default: :connections
  # config.connection_table_name = :connections

  # Model name for the user model (the model that includes TenCubedUser)
  # Default: "User"
  # config.user_model_name = "User"

  # Table name for the user model
  # Default: "users"
  # config.user_table_name = "users"

  # Class name for the connection model
  # Default: "TenCubed::Connection"
  # config.connection_class_name = "TenCubed::Connection"
end
