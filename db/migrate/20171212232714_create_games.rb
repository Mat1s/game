class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.decimal :bid
      t.decimal :profit
      t.string :currency
      t.belongs_to :user
      t.timestamps
    end
  end
end
