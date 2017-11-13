class Student < ApplicationRecord
  has_many :answers
  has_many :approved_subjects
  has_many :subjects, through: :approved_subjects

  validates_presence_of :name, :email, :identity_document
  validates_uniqueness_of :identity_document
end
