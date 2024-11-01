namespace :stocks do
  desc "Fetch and update stock prices"
  task update: :environment do
    stocks_data = StockApi.fetch_stocks

    stocks_data.each do |stock|
      symbol = stock['Symbol']
      last_trade_price = stock['LTP']
      stock_record = Stock.find_or_initialize_by(symbol: symbol)
      stock_record.last_trade_price = last_trade_price
      stock_record.save
    end

    puts "Stock prices updated successfully!"
  end
end
