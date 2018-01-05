require 'curb'
require 'nokogiri'

path = 'http://www.xe.com/currencytables/?from=EUR&date='
date = '2017-12-23'#"#{DateTime.now.strftime("%F")}"
if Nokogiri::HTML(Curl::Easy.perform(path+date).body_str).xpath("//*[@id='ictErrors']")
	date = '2017-12-22'
end
all_page = Nokogiri::HTML(Curl::Easy.perform(path+date).body_str)
p date


	i = 1 
	currencies = []
	all_currency = {}
	currency = ''

	while(currency != 'ZMW')
		currency = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[1]/a/text()").to_s
		currency_value = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[3]/text()").to_s
		currency_full_name = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[2]/text()").to_s
		i+=1
		all_currency["#{currency}"] = currency_value
		currencies << (currency + "-" + currency_full_name)
	end
	p all_currency
	p all_currency["EUR"]
	p currencies
# path = 'http://www.xe.com/currencytables/?from=EUR&date='
# 		date = "#{time_now.strftime("%F")}"
# 		if Nokogiri::HTML(Curl::Easy.perform(path+date).body_str).xpath("//*[@id='ictErrors']")
# 			date = "#{time_now.yesterday.strftime("%F")}"
# 		end
# 		all_page = Nokogiri::HTML(Curl::Easy.perform(path+date).body_str)
		
# 		currency = ''
# 		i = 0
# 		while(currency != 'ZMW')
# 			currency = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[1]/a/text()").to_s
# 			currency_value = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[3]/text()").to_s
# 			currency_full_name = all_page.xpath("//*[@id='historicalRateTbl']/tbody/tr[#{i}]/td[2]/text()").to_s
# 		 	i+=1
# 		 	Currency.where(name: currency).first_or_create! do |cur|
# 		 		cur.full_name = currency_full_name
# 		 		cur.cost_eur = currency_value
		 	
# 		 	end