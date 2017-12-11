class Answer < ApplicationRecord
  belongs_to :student
  belongs_to :chair
  belongs_to :reply_option
  belongs_to :survey

  APRROVED_SUBJECT = 'approved'.freeze
  NOT_THIS_QUARTER = 'dont'.freeze
  SCHEDULE_PROBLEM = 'cant'.freeze
  validates_presence_of :student
  validates_presence_of :reply_option, if: -> { chair.blank? }
  validates_presence_of :chair, if: -> { reply_option.blank? }

  def choice_info
    if reply_option.present?
      { name: reply_option.subject.name, selection: 'cant' }
    else
      { name: chair.subject.name, selection: chair.time }
    end
  end

  def subject_name
    reply_option.try(:subject_name) || chair.subject_name
  end
end
