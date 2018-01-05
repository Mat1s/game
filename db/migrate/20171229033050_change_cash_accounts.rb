class ChangeCashAccounts < ActiveRecord::Migration[5.0]
  def change
  	add_column :cash_accounts, :total, :decimal
  	CashAccount.find_each do |ca|
  		ca.total = ca.sum
  		ca.save
  	end
  	remove_column :cash_accounts, :sum
  end
end
