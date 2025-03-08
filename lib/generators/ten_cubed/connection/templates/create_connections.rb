# frozen_string_literal: true
# Created by AI

class CreateConnections < ActiveRecord::Migration[<%= migration_version %>]
  def change
    create_table :connections do |t|
      t.references :user, null: false, foreign_key: true
      t.references :target, null: false, foreign_key: { to_table: :users }
      
      t.timestamps
    end
    
    add_index :connections, [:user_id, :target_id], unique: true
  end
end