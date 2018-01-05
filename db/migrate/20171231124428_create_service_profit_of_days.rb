class CreateServiceProfitOfDays < ActiveRecord::Migration[5.0]
  def change
    create_table :profit_services, id: :bigserial do |t|
    	t.decimal :profit_from_game, null: false
    	t.string :currency, null: false, default: 'EUR'

      t.timestamps
    end
  end
end
