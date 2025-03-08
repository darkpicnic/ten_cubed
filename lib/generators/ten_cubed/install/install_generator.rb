# frozen_string_literal: true

# Created by AI

module TenCubed
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path("templates", __dir__)
      desc "Install TenCubed into your Rails application"

      # Required for Rails::Generators::Migration
      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def add_migrations
        rails_command "railties:install:migrations FROM=ten_cubed", inline: true
      end

      def create_initializer
        template "initializer.rb", "config/initializers/ten_cubed.rb"
      end

      def setup_user_model
        if model_exists?("User")
          add_max_degree_to_existing_user
          inject_ten_cubed_user_concern
        else
          generate "ten_cubed:user"
        end
      end

      def setup_connection_model
        if model_exists?("Connection")
          # Throw an error if Connection model already exists
          raise "Connection model already exists. Please remove it or rename it before installing TenCubed."
        else
          generate "ten_cubed:connection"
        end
      end

      private

      def model_exists?(model_name)
        File.exist?(Rails.root.join("app", "models", "#{model_name.underscore}.rb"))
      end

      def add_max_degree_to_existing_user
        migration_template "add_max_degree_to_users.rb",
          "db/migrate/add_max_degree_to_users.rb",
          migration_version: migration_version
      end

      def inject_ten_cubed_user_concern
        inject_into_file "app/models/user.rb", after: "class User < ApplicationRecord\n" do
          "  include TenCubed::Models::Concerns::TenCubedUser\n"
        end
      end

      def migration_version
        if Rails.version >= '5.0.0'
          rails_version = ENV['RAILS_VERSION'] || "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"
          "[#{rails_version}]"
        end
      end
    end
  end
end
