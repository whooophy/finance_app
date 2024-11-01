# lib/stock_api.rb
require 'net/http'
require 'json'

module StockApi
  BASE_URL = "https://latest-stock-price.p.rapidapi.com/equities"

  def self.fetch_stocks
    uri = URI(BASE_URL)
    request = Net::HTTP::Get.new(uri)
    request["x-rapidapi-host"] = ENV['RAPIDAPI_HOST']
    request["x-rapidapi-key"] = ENV['RAPIDAPI_KEY']

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    p response

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      puts "Failed to fetch stock prices: #{response.message}"
      []
    end
  end

  def self.get_price(symbol)
    uri = URI("#{BASE_URL}?Symbols=#{symbol}")
    request = Net::HTTP::Get.new(uri)
    request["x-rapidapi-host"] = ENV['RAPIDAPI_HOST']
    request["x-rapidapi-key"] = ENV['RAPIDAPI_KEY']

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      return data[0]['LTP'].to_f unless data.empty?
    else
      puts "Failed to fetch stock prices: #{response.message}"
    end
    nil
  end

  def self.search_assets(query)
    return [] if query.length < 2

    uri = URI("https://latest-stock-price.p.rapidapi.com/equities-search?Search=#{query}")
    p uri
    request = Net::HTTP::Get.new(uri)
    request["x-rapidapi-host"] = ENV['RAPIDAPI_HOST']
    request["x-rapidapi-key"] = ENV['RAPIDAPI_KEY']

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      puts "Failed to search assets: #{response.message}"
      []
    end
  end

end
