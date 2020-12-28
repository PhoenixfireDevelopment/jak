# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :key
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
    add_index :roles, :key
  end
end
