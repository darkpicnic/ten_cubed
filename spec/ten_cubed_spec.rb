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

    it "has default user_model_name" do
      config = TenCubed::Configuration.new
      expect(config.user_model_name).to eq("User")
    end

    it "has default user_table_name" do
      config = TenCubed::Configuration.new
      expect(config.user_table_name).to eq("users")
    end

    it "has default connection_class_name" do
      config = TenCubed::Configuration.new
      expect(config.connection_class_name).to eq("TenCubed::Connection")
    end

    it "allows configuring user_model_name, user_table_name, and connection_class_name" do
      TenCubed.configure do |config|
        config.user_model_name = "Member"
        config.user_table_name = "members"
        config.connection_class_name = "Connection"
      end

      expect(TenCubed.configuration.user_model_name).to eq("Member")
      expect(TenCubed.configuration.user_table_name).to eq("members")
      expect(TenCubed.configuration.connection_class_name).to eq("Connection")
    end
  end
end
