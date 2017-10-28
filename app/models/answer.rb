class Answer < ApplicationRecord
  belongs_to :student
  validates_presence_of :student
end
