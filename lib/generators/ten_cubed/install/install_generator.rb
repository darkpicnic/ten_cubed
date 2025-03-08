# frozen_string_literal: true
# Created by AI

module TenCubed
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Install TenCubed into your Rails application"

      def add_migrations
        rails_command "railties:install:migrations FROM=ten_cubed", inline: true
      end

      def create_initializer
        template "initializer.rb", "config/initializers/ten_cubed.rb"
      end

      def mount_engine
        route 'mount TenCubed::Engine => "/ten_cubed"'
      end

      def add_user_migration
        if model_exists?("User")
          add_max_degree_to_existing_user
        else
          say "No User model found. Skipping user migration."
          say "Run 'rails g ten_cubed:user' to create a User model with ten_cubed functionality."
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

      def migration_version
        if Rails.version >= "5.0.0"
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  end
end 