class SurveysController < ApplicationController
  include SurveyService

  def create
    success_message = []
    student = academic_record.find_student_with(token: params[:userId])
    success_message = generate_survey(student, success_message)
    render json: generate_success_message(success_message), status: :ok
  end

  def new
    survey_subjects = survey_submissions.last_survey_subjects(student)

    render json: build_survey(survey_subjects), status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def edit
    survey = Survey.select(:id).last
    answers = survey_submissions.obtain_answers(survey, student)
    head(:not_found) && return if answers.empty?

    render json: build_editable_survey(answers, survey_submissions.last_survey_subjects(student)), status: :ok
  rescue ActiveRecord::RecordNotFound
    head :unauthorized
  end

  private

  def survey_submissions
    @submissions ||= SurveySubmissions.new
  end

  def student
    token = params[:token] || params[:id]
    @student ||= Student.includes(:subjects).find_by!(token: token)
  end

  def build_survey(survey_subjects)
    survey_subjects.map { |subject| { name: subject.name, chairs: subject.chairs.map(&:time), selected: '' } }
  end

  def build_editable_survey(answers, subjects)
    answers_info = answers.map(&:choice_info)
    build_survey(subjects).map do |survey_subject|
      answer = answers_info.detect { |info| info[:name] == survey_subject[:name] }
      survey_subject.tap { |subject| subject[:selected] = answer[:selection] if answer.present? }
    end
  end
end
