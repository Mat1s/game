class CreateTopOfBids < ActiveRecord::Migration[5.0]
  def change
    create_table :top_of_bids, id: :bigserial do |t|
    	t.string :currency_of_bid, null: false
    	t.decimal :profit_in_euro, null: false
    	t.string :user_email, null: false
      t.timestamps
    end
  end
end
