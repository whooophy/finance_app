class RenameTypeInUserHistories < ActiveRecord::Migration[7.0]
  def change
    rename_column :user_histories, :type, :type_of
  end
end