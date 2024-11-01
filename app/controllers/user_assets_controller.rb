class UserAssetsController < ApplicationController
  def buy
    required_params = [:user_id, :symbol, :volume]
    missing_params = required_params.select { |param| params[param].blank? }

    unless missing_params.empty?
      render json: { error: "Missing parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    user_id = params[:user_id]
    asset_symbol = params[:symbol]
    volume = params[:volume].to_i

    user = User.find_by(id: user_id)

    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    stock = Stock.find_by(symbol: asset_symbol)
    if stock.nil?
      render json: { error: "Stock not found" }, status: :not_found
      return
    end

    last_trade_price = StockApi.get_price(asset_symbol)
    if last_trade_price.nil?
      # if fail get latest price from api, then use data from stock
      last_trade_price = stock.last_trade_price
    end

    total_cost = last_trade_price * volume
    if user.balance < total_cost
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
      return
    end

    user_asset = UserAsset.create(
      user: user,
      stock: stock,
      buy_price: stock.last_trade_price,
      volume: volume,
      status: :pending
    )

    render json: {
      asset: {
        id: user_asset.id,
        symbol: user_asset.stock.symbol,
        last_trade_price: user_asset.buy_price,
        volume: user_asset.volume,
        status: user_asset.status
      }
    }, status: :created
  end

  def confirm_buy
    required_params = [:user_id, :asset_id]
    missing_params = required_params.select { |param| params[param].blank? }

    unless missing_params.empty?
      render json: { error: "Missing parameters: #{missing_params.join(', ')}" }, status: :bad_request
      return
    end

    user_id = params[:user_id]
    asset_id = params[:asset_id]

    user = User.find_by(id: user_id)

    if user.nil?
      render json: { error: "User not found" }, status: :not_found
      return
    end

    user_asset = UserAsset.find_by(id: asset_id, user: user)

    if user_asset.nil?
      render json: { error: "UserAsset not found" }, status: :not_found
      return
    end

    if user_asset.status != 'pending'
      render json: { error: "UserAsset is not in pending status" }, status: :unprocessable_entity
      return
    end

    total_cost = user_asset.buy_price * user_asset.volume
    if user.balance < total_cost
      render json: { error: "Insufficient balance" }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      user.update!(balance: user.balance - total_cost)
      user_asset.update!(status: :buy)
    end

    render json: {
      asset: {
        id: user_asset.id,
        symbol: user_asset.stock.symbol,
        last_trade_price: user_asset.buy_price,
        volume: user_asset.volume,
        status: user_asset.status
      }
    }, status: :ok
  end

  def search
    query = params[:query]

    if query.blank? || query.length < 2
      render json: { error: "Query must be at least 2 characters long" }, status: :bad_request
      return
    end

    results = StockApi.search_assets(query)

    render json: { results: results }, status: :ok
  end
end
