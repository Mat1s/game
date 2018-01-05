class CreateCashAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :cash_accounts do |t|
      t.string :currency
      t.decimal :sum      
      t.timestamps
    end
  end
end
