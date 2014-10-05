class CreateTransactionTypes < ActiveRecord::Migration
  def change
    create_table :transaction_types do |t|
      t.string :title
      t.integer :direction

      t.timestamps
    end
  end
end
