class Student < ApplicationRecord
  has_many :answers
  has_many :approved_subjects
  validates_presence_of :name, :identity_document, :email
end
