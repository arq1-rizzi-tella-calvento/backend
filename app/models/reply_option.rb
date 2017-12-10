class ReplyOption < ApplicationRecord
  belongs_to :subject

  CONFLICTING_SCHEDULES = 'No puedo cursar'.freeze
  REPLY_OPTIONS = ['No voy a cursar', CONFLICTING_SCHEDULES].freeze
  validates :value, inclusion: { in: REPLY_OPTIONS }
  validates_presence_of :value, :subject

  def self.with_conflicting_schedules(subject)
    new.tap do |reply_option|
      reply_option.subject = subject
      reply_option.value = CONFLICTING_SCHEDULES
    end
  end

  def subject_name
    subject.name
  end
end
