class ReplyOption < ApplicationRecord
  REPLY_OPTIONS = ['No voy a cursar', 'No puedo cursar'].freeze
  validates :value, inclusion: { in: REPLY_OPTIONS }
  validates_presence_of :value
end
