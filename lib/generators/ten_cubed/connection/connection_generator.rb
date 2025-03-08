# frozen_string_literal: true

# Created by AI

module TenCubed
  module Generators
    class ConnectionGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("templates", __dir__)
      desc "Create Connection model and migration for TenCubed"

      # Required for Rails::Generators::Migration
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_connection_model
        template "connection.rb", "app/models/connection.rb"
      end

      def create_connection_migration
        migration_template "create_connections.rb",
          "db/migrate/create_connections.rb",
          migration_version: migration_version
      end

      private

      def migration_version
        if Rails.version >= '5.0.0'
          rails_version = ENV['RAILS_VERSION'] || "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
          "[#{rails_version}]"
        end
      end
    end
  end
end
