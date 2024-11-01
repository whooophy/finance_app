class CreateUserAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :user_assets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.decimal :buy_price
      t.integer :volume

      t.timestamps
    end
  end
end
