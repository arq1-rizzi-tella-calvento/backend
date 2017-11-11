class SubjectInQuarter < ApplicationRecord
  belongs_to :subject
  belongs_to :survey

  validates_presence_of :subject, :survey
end
