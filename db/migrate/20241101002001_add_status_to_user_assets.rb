class AddStatusToUserAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :user_assets, :status, :string, default: 'pending'
  end
end
