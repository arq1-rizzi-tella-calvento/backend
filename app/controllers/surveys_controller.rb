class SurveysController < ApplicationController
  include SurveyService

  def create
    success_message = []
    params[:subjects].each do |subject|
      current_subject = Subject.find_by(name: subject[:name])
      student_answer = subject[:selectedChair]
      if student_answer == 'approve'
      #   tenemos que asignarla a las materias aprobadas no como una respuesta
      else
        success_message = submit_answer(current_subject, student_answer, subject, success_message)
      end
    end

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
