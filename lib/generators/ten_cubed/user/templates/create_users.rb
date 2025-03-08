# frozen_string_literal: true
# Created by AI

class CreateUsers < ActiveRecord::Migration[<%= migration_version %>]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false, default: ""
      t.integer :max_degree, default: 3, null: false
      
      # Add any other fields needed for your User model
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
  end
end 