class User < ApplicationRecord
  has_many :tasks

  validates :name, presence: true, length: { maximum: 50 }

  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 500 }, uniqueness: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
