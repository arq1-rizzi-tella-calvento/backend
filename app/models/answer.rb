class Answer < ApplicationRecord
  belongs_to :student
  belongs_to :chair
  belongs_to :reply_option

  validates_presence_of :student
  validates_presence_of :reply_option, if: -> { chair.blank? }
  validates_presence_of :chair, if: -> { reply_option.blank? }
end
