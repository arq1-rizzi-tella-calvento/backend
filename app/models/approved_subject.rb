class ApprovedSubject < ApplicationRecord
  belongs_to :student
  belongs_to :subject

  validates_presence_of :student, :subject
end
