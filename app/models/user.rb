class User < ApplicationRecord
  belongs_to :team
  has_many :user_histories
end
