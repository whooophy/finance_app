class UserAsset < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum status: { pending: 'pending', buy: 'buy', sell: 'sell' }
end
