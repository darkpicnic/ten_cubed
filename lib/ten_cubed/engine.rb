# frozen_string_literal: true
# Created by AI

require "rails"
require "active_record"
require "active_support/all"

module TenCubed
  class Engine < ::Rails::Engine
    isolate_namespace TenCubed

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    initializer "ten_cubed.check_postgres" do
      ActiveSupport.on_load(:active_record) do
        unless ActiveRecord::Base.connection.adapter_name =~ /postgresql/i
          raise "TenCubed requires PostgreSQL as the database adapter. Found: #{ActiveRecord::Base.connection.adapter_name}"
        end
      end
    end

    initializer "ten_cubed.load_concerns" do
      ActiveSupport.on_load(:active_record) do
        require "ten_cubed/models/concerns/ten_cubed_user"
      end
    end

    config.to_prepare do
      if defined?(User)
        User.include TenCubed::Models::Concerns::TenCubedUser
      end
    end
  end
end 