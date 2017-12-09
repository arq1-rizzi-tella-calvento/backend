class Subject < ApplicationRecord
  has_one :subject_in_quarter
  has_many :chairs, through: :subject_in_quarter
  has_many :reply_options, through: :reply_options_subjects

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
end
