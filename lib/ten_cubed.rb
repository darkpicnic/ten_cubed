# frozen_string_literal: true

require "active_record"
require_relative "ten_cubed/version"

module TenCubed
  class Error < StandardError; end

  # Configuration
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

require_relative "ten_cubed/configuration"
require_relative "ten_cubed/connection"
require_relative "ten_cubed/models/concerns/ten_cubed_user"
require_relative "ten_cubed/engine" if defined?(Rails)
