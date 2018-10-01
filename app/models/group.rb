class Group < ApplicationRecord
  belongs_to :user

  has_many :joins, dependent: :destroy
  has_many :join_users, through: :joins, source: :user
end
