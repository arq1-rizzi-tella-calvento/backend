class SurveysController < ApplicationController
  include SurveyService

  def create
    success_message = []
    student = academic_record.find_student_with(token: params[:userId])
    success_message = generate_survey(student, success_message)
    render json: generate_success_message(success_message), status: :ok
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
end
