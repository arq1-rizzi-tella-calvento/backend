class Chair < ApplicationRecord
  belongs_to :subject
  validates_presence_of :subject
end
