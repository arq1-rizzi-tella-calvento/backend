class Survey < ApplicationRecord
  has_many :subject_in_quarters
  has_many :answers
  has_many :subjects, through: :subject_in_quarters

  scope :active, -> { where('start_date <= ? and end_date >= ?', Time.current, Time.current) }
end
