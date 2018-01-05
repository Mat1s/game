class CurrencyWorker
	include Sidekiq::Worker
	sidekiq_options retry: false
	
	def perform()
   
    path = 'http://www.xe.com/currencytables/?from=EUR&date='
		
		date = "#{DateTime.now.strftime("%F")}"
		if Nokogiri::HTML(Curl::Easy.perform(path+date).body_str).xpath("//*[@id='ictErrors']")
			date = "#{DateTime.now.yesterday.strftime("%F")}"
		end
		
		all_page = Nokogiri::HTML(Curl::Easy.perform(path+date).body_str)
		
		currency = ''
		i = 1
		while(currency != 'ZMW')
			currency = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[1]/a/text()").to_s
			currency_value = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[3]/text()").to_s
			currency_full_name = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[2]/text()").to_s
		 	i+=1
		 	Currency.where(name: currency).first_or_create! do |cur|
		 		cur.full_name = currency_full_name
		 		cur.cost_eur = currency_value
		 		cur.save
		 	end
		end
  end
end