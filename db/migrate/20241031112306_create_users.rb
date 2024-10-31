class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.references :team, foreign_key: true
      t.decimal :balance, precision: 10, scale: 2
      t.timestamps
    end
  end
end