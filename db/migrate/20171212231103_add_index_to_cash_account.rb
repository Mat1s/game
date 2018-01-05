class AddIndexToCashAccount < ActiveRecord::Migration[5.0]
  def change
  	change_table :cash_accounts do |t|
  		t.belongs_to :user
  		t.index([:user_id, :currency], unique: true, using: :btree)
  	end
  end
end
