class SurveysController < ApplicationController
  def create
    rand
    render json: { message: 'Survey successfully submitted' }, status: :ok
  end

  def new
    approved_subject_ids = student.subjects.pluck(:id)
    survey_subjects = Survey.includes(:subjects).last.subjects.where.not(id: approved_subject_ids)

    render json: build_survey(survey_subjects), status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def student
    Student.includes(:subjects).find_by!(token: params[:token])
  end

  def build_survey(survey_subjects)
    survey_subjects.map { |subject| { name: subject.name, chairs: subject.chairs.map(&:time) } }
  end
end
