class UserHistory < ApplicationRecord
  belongs_to :user

  validates :balance_before, presence: true
  validates :balance_after, presence: true
  validates :txID, presence: true, uniqueness: true
  validates :type_of, inclusion: { in: ['credit', 'debit'] }

end
