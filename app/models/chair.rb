class Chair < ApplicationRecord
  belongs_to :subject_in_quarter
  validates_presence_of :subject_in_quarter

  has_many :answers
  has_many :students, through: :answers

  scope :with_over_demand, -> { joins(:answers).having('COUNT(answers.id) > quota').group('id') }

  def number_of_students
    answers.size
  end
end
