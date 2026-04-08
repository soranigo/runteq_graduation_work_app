class Plan < ApplicationRecord
  validates :name, presence: true
  validates :starting_day_of_week, presence: true
  validates :ending_day_of_week, presence: true
  validates :starting_time, presence: true
  validates :ending_time, presence: true

  include DayOfWeek

  enum starting_day_of_week: DAYS_OF_WEEK, _prefix: :starting
  enum ending_day_of_week: DAYS_OF_WEEK, _prefix: :ending

  belongs_to :user
  belongs_to :schedule

  def self.current_day_of_week_value
    current_day = Time.zone.now.strftime("%a").downcase.to_sym
    DAYS_OF_WEEK[current_day]
  end

  def self.current_time_value
    current_time = Time.zone.now.strftime("%H:%M")
  end
end
