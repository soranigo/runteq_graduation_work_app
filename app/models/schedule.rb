class Schedule < ApplicationRecord
  validates :name, presence: true, length: { maximum: 32 }

  include DayOfWeek

  belongs_to :user
  has_many :plans, dependent: :destroy
end
