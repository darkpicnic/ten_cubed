# frozen_string_literal: true
# Created by AI

module TenCubed
  module Generators
    class ConnectionGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Create Connection model and migration for TenCubed"

      def create_connection_migration
        migration_template "create_connections.rb",
          "db/migrate/create_connections.rb",
          migration_version: migration_version
      end

      private

      def migration_version
        if Rails.version >= "5.0.0"
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  end
end 