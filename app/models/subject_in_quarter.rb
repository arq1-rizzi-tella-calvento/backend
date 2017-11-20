class SubjectInQuarter < ApplicationRecord
  belongs_to :subject
  belongs_to :survey
  has_many :chairs

  validates_presence_of :subject, :survey

  delegate :name, to: :subject
end
