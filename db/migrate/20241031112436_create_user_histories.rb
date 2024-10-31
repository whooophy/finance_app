class CreateUserHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :user_histories do |t|
      t.decimal :balance_before, precision: 10, scale: 2
      t.decimal :balance_after, precision: 10, scale: 2
      t.string :txID
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
