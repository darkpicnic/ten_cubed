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
        user_file = "app/models/user.rb"

        if File.exist?(user_file)
          # Check if the file already has the include statement
          contents = File.read(user_file)
          if contents.include?("include TenCubed::Models::Concerns::TenCubedUser")
            say_status :identical, "User model already includes TenCubedUser", :blue
          else
            # Insert the include statement after the class declaration
            inject_into_file user_file, after: /class User < .*\n/ do
              "  include TenCubed::Models::Concerns::TenCubedUser\n"
            end
            say_status :insert, "include TenCubed::Models::Concerns::TenCubedUser added to User model", :green
          end
        else
          # Create a new user.rb file from template
          template "user.rb", user_file
        end
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
