class Survey < ApplicationRecord
  has_many :subject_in_quarters
  has_many :answers
  has_many :subjects, through: :subject_in_quarters
end
