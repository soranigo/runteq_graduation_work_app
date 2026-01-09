class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 16 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }
end
