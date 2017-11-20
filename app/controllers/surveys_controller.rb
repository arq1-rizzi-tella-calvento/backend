class SurveysController < ApplicationController
  def create
    rand
    render json: { message: 'Survey successfully submitted' }, status: :ok
  end

  def new
    approved_subject_ids = Student.includes(:subjects).find(student_id).subjects.pluck(:id)
    survey_subjects = Survey.includes(:subjects).last.subjects.where.not(id: approved_subject_ids)

    render json: build_survey(survey_subjects), status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def student_id
    params.permit(:student_id)[:student_id]
  end

  def build_survey(survey_subjects)
    survey_subjects.map { |subject| { name: subject.name, chairs: subject.chairs.map(&:time) } }
  end
end
