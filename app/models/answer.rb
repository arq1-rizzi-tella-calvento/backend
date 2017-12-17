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
    { name: subject_name, selected: selection }
  end

  def subject_name
    reply_option.try(:subject_name) || chair.subject_name
  end

  def subject
    chair.try(:subject) || reply_option.subject
  end

  def selection
    chair.try(:id) || SCHEDULE_PROBLEM
  end
end
