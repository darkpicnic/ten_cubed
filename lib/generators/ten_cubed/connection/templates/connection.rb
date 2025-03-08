# frozen_string_literal: true

# Created by AI

class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :target, class_name: "User"

  validate :ensure_user_has_less_than_max_connections, on: :create
  validate :ensure_target_is_not_self, on: :create

  private

  def ensure_user_has_less_than_max_connections
    if user.connections.count >= 10
      errors.add(:user, "can't have more than 10 connections")
    end
  end

  def ensure_target_is_not_self
    if user == target
      errors.add(:target, "can't be the same as user")
    end
  end
end
