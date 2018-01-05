class RemoveIndexFromCachAccounts < ActiveRecord::Migration[5.0]
  def change
  	change_table :cash_accounts do |t|
  		t.remove_index name: "index_cash_accounts_on_user_id"
  	end
  end
end
