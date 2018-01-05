class ChangeIdInCashAccount < ActiveRecord::Migration[5.0]
  def change
  	change_column :cash_accounts, :id, :bigint
  end
end
