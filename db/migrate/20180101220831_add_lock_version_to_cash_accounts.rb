class AddLockVersionToCashAccounts < ActiveRecord::Migration[5.0]
  def change
  	add_column :cash_accounts, :lock_version, :integer, default: 0
  end
end
