# frozen_string_literal: true

# Created by AI

RSpec.describe TenCubed do
  it "has a version number" do
    expect(TenCubed::VERSION).not_to be nil
  end

  describe ".configure" do
    it "allows configuration" do
      TenCubed.configure do |config|
        config.max_direct_connections = 5
        config.max_network_depth = 2
        config.connection_table_name = :test_connections
      end

      expect(TenCubed.configuration.max_direct_connections).to eq(5)
      expect(TenCubed.configuration.max_network_depth).to eq(2)
      expect(TenCubed.configuration.connection_table_name).to eq(:test_connections)
    end
  end
end
