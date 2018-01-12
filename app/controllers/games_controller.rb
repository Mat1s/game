class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_of_black_list, only: :create
  around_action :correct_money, only: :create
  after_action :profit_of_service, only: :create
  respond_to :html, :js

  def index
  	@game = current_user.games.new
  	@games = current_user.games.order(created_at: :desc).limit(20)
  	@cash_accounts = current_user.cash_accounts if current_user.cash_accounts.any?
  	@cash_accounts_u = current_user.cash_accounts.
  		select('cash_accounts.user_id, cash_accounts.currency currency, currencies.full_name full_name').
  		joins('left join currencies on cash_accounts.currency = currencies.name')
  	@top_wins = TopOfBid.select('profit_in_euro profit, user_email email').order(profit_in_euro: :desc).limit(100)
  end

  def new
  	@game = current_user.games.new
  	@cash_accounts_u = current_user.cash_accounts.
  		select('cash_accounts.user_id, cash_accounts.currency currency, currencies.full_name full_name').
  		joins('left join currencies on cash_accounts.currency = currencies.name')
  end

  def sheduler
  	CurrencyWorker.perform_in(1.day)
  	render text: "Shedule is start"
  end

  def create
  	@game = current_user.games.new(permit_params)
  	max = (params[:game][:bid].to_d)*2
  	path = "https://www.random.org/integers/?num=1&min=0&max=#{max}&col=1&base=10&format=plain&rnd=new"
		@profit = Net::HTTP.get_response(URI(path)).body.chomp.to_i
		
		if current_user.games.create(bid: params[:game][:bid], profit: @profit, currency: params[:game][:currency],
			user_id: params[:user_id])
			flash.now[:success] = "Your profit is #{@profit}"
		else
			flash.now[:alert] = "Not acceptable params"
		end
	end

  private 
 
 	def permit_params
  	params.require(:game).permit(:currency, :user_id, :bid)
  end

  def check_user_of_black_list
  	path = "https://www.random.org/integers/?num=1&min=0&max=500&col=1&base=10&format=plain&rnd=new"
  	if Net::HTTP.get_response(URI(path)).body.chomp.to_i == 0
  		flash[:alert] = "You are in black list. Try other user"
  		redirect_to games_path, status: 406
  	end
  end

  def correct_money
  	current_account = CashAccount.find_by(user_id: current_user.id, currency: params[:game][:currency])
  	total = current_account.total
  	period = Time.now - 1.day
  	profit_of_service = 0.5*(ProfitService.where("created_at > :period", period: period).sum(:profit_from_game))
  	if params[:game][:bid].to_d > total
  		render @games, alert: "Your bid must be less than #{total} #{params[:game][:currency]}"
  		current_account.lock_version = 0
  	elsif params[:game][:bid].to_d > profit_of_service
  		render @games, alert: "Your bid must be less than #{profit_of_service} Euro"
  		current_account.lock_version = 0
  	end
		logger.debug "Current account is: #{current_account.inspect}"
  	yield  	
  	total_after_bid = total - params[:game][:bid].to_d + @profit.to_d
 		current_account.update(total: total_after_bid)  
  end

  def profit_of_service
  	ProfitOfDayWorker.perform_async(params[:game][:currency], params[:game][:bid], @profit, current_user.id)
  end
end
