# frozen_string_literal: true
# Created by AI

module TenCubed
  module Generators
    class UserGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("templates", __dir__)
      desc "Create a User model with ten_cubed functionality"

      # Required for Rails::Generators::Migration
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def create_user_model
        template "user.rb", "app/models/user.rb"
      end

      def create_user_migration
        migration_template "create_users.rb",
          "db/migrate/create_users.rb",
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