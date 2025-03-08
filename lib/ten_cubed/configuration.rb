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

    def initialize
      @max_direct_connections = 10
      @max_network_depth = 3
      @connection_table_name = :connections
    end
  end
end
