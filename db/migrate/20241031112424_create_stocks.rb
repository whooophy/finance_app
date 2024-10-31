class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.decimal :last_trade_price, precision: 10, scale: 2
      t.string :symbol
      t.timestamps
    end
  end
end