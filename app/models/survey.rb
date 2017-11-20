class Survey < ApplicationRecord
  has_many :subject_in_quarters
  has_many :answers
end
