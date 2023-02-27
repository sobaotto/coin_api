class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.integer :type, null: false
      t.bigint :amount, null: false, default: 0

      t.timestamps
    end
  end
end
