# frozen_string_literal: true

class CreateLeads < ActiveRecord::Migration[5.2]
  def change
    create_table :leads do |t|
      t.string :name
      t.references :assignable, index: true
      t.belongs_to :company, index: true

      t.timestamps
    end
  end
end
