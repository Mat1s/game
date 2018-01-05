class CreateCurrencies < ActiveRecord::Migration[5.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :full_name
      t.decimal :cost_eur

      t.timestamps
    end
  end
end
