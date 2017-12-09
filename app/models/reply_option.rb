class ReplyOption < ApplicationRecord
  belongs_to :subject

  REPLY_OPTIONS = ['No voy a cursar', 'No puedo cursar'].freeze
  validates :value, inclusion: { in: REPLY_OPTIONS }
  validates_presence_of :value, :subject_id
end
