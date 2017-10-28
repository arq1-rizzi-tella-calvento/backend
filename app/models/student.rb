class Student < ApplicationRecord
  has_many :answers
  validates_presence_of :name, :identity_document, :email
end
