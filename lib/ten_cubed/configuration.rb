# frozen_string_literal: true

# Created by AI

module TenCubed
  class Configuration
    # Default maximum direct connections allowed
    attr_accessor :max_direct_connections

    # Default maximum network depth allowed
    attr_accessor :max_network_depth

    # Table name for the connections table
    attr_accessor :connection_table_name

    # Model name for the user model (the model that includes TenCubedUser)
    attr_accessor :user_model_name

    # Table name for the user model
    attr_accessor :user_table_name

    # Class name for the connection model
    attr_accessor :connection_class_name

    def initialize
      @max_direct_connections = 10
      @max_network_depth = 3
      @connection_table_name = :connections
      @user_model_name = "User"
      @user_table_name = "users"
      @connection_class_name = "TenCubed::Connection"
    end
  end
end
