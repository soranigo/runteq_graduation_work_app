class Plan < ApplicationRecord
  validates :name, presence: true
  validates :starting_day_of_week, presence: true
  validates :ending_day_of_week, presence: true
  validates :starting_time, presence: true
  validates :ending_time, presence: true

  DAYS_OF_WEEK = { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 }

  enum starting_day_of_week: DAYS_OF_WEEK, _prefix: :starting
  enum ending_day_of_week: DAYS_OF_WEEK, _prefix: :ending

  belongs_to :user
  belongs_to :schedule
end
