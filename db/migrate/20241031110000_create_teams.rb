class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.decimal :total_balance, precision: 10, scale: 2
      t.timestamps
    end
  end
end