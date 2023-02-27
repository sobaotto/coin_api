# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.bigint :balance, null: false, default: 0
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, %i[name email], unique: true
  end
end
