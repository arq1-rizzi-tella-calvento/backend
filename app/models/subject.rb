class Subject < ApplicationRecord
  has_many :chairs
  has_many :reply_options, through: :reply_options_subjects
  validates_presence_of :name
end
