# frozen_string_literal: true
# Created by AI

require "active_record"

module TenCubed
  class Connection < ::ActiveRecord::Base
    def self.table_name
      TenCubed.configuration.connection_table_name.to_s
    end

    if defined?(::User)
      belongs_to :user, class_name: "::User"
      belongs_to :target, class_name: "::User"
    else
      # For tests
      attr_accessor :user, :target
    end

    validate :ensure_user_has_less_than_max_connections, on: :create
    validate :ensure_target_is_not_self, on: :create

    private

    def ensure_user_has_less_than_max_connections
      if user && user.connections.count >= TenCubed.configuration.max_direct_connections
        errors.add(:user, "can't have more than #{TenCubed.configuration.max_direct_connections} connections")
      end
    end

    def ensure_target_is_not_self
      if user && target && user == target
        errors.add(:target, "can't be the same as user")
      end
    end
  end
end 