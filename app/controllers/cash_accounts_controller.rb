class CashAccountsController < ApplicationController
	before_filter :authenticate_user!
	def new
		@cash_account = current_user.cash_accounts.new
		@type_currency = Currency.all
	end

	def create
		begin
			@cash_account = current_user.cash_accounts.new(permit_params)
			if @cash_account.save
				redirect_to cash_accounts_path, notice: "cash account successfuly created"
			else
				render new_cash_account, alert: "please, try again"
			end
		rescue StandardError => e
			flash[:error] = " Please choose other currency"
			logger.warn "#{e}"
			redirect_to new_cash_account_path
		end
	end

	def destroy
		@cash_account = current_user.cash_accounts.find(params[:id])
		if @cash_account.delete
			redirect_to cash_accounts_path, alert: "Cash account eliminated"
		end
	end

	def index
		@cash_accounts = current_user.cash_accounts
	end

	def edit
		@cash_account = current_user.cash_accounts.find(params[:id])
	end

	def update
		@cash_account = current_user.cash_accounts.find(params[:id])
		if @cash_account.update_attributes(premit_update_params)
			redirect_to cash_accounts_path
			flash[:info] = "successfuly updated"
		else
			render :new

		end
	end
	
	private

	def permit_params
		params.require(:cash_account).permit(:currency, :total, :user_id)
	end

	def premit_update_params
		params.require(:cash_account).permit(:total, :user_id)
	end	
end
