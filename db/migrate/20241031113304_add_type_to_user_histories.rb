class AddTypeToUserHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :user_histories, :type, :string
  end
end
