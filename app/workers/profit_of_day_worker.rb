class ProfitOfDayWorker
  include Sidekiq::Worker

  def perform(currency, bid, profit, id)
  	profit_from_game = bid.to_d - profit.to_d
  	cur = Currency.find_by(name: currency).cost_eur
  	profit_in_euro = profit_from_game/cur
  	if -profit_in_euro > 0
  		  user = User.find_by(id: id)
        email = user.email
  			TopOfBid.create(profit_in_euro: profit_in_euro.abs, user_email: email, currency_of_bid: currency)
  	end
  	ProfitService.create(profit_from_game: profit_in_euro)
  end
end
