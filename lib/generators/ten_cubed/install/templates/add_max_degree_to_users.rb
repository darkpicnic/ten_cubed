# frozen_string_literal: true
# Created by AI

class AddMaxDegreeToUsers < ActiveRecord::Migration[<%= migration_version %>]
  def change
    add_column :users, :max_degree, :integer, default: 3, null: false
  end
end