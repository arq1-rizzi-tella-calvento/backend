class Student < ApplicationRecord
  has_secure_token

  has_many :answers
  has_many :approved_subjects
  has_many :subjects, through: :approved_subjects

  validates_presence_of :email
  validates_presence_of :name, :identity_document, on: :enroll
  validates_uniqueness_of :identity_document, on: :enroll
  validates_uniqueness_of :email
end
