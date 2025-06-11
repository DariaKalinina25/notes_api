# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :archived, null: false, default: false

      t.timestamps
    end
  end
end
