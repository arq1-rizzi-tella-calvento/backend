class SurveysController < ApplicationController
  include SurveyService

  rescue_from ActiveRecord::RecordNotFound, with: -> { head :unauthorized }

  def create
    survey = survey_submissions.find_survey(survey_args[:surveyId])
    answers = survey_submissions.create_answers(student, survey, survey_args[:subjects])

    render json: generate_survey_response(answers, student), status: :ok
  rescue SurveySubmissions::INVALID_ANSWER
    invalid_chair
  rescue SurveySubmissions::InvalidSurveyActionError
    render json: { msg: 'Usted ya completo la encuesta, por favor use el link de editar' }, status: :bad_request
  end

  def new
    survey = survey_submissions.current_survey
    survey_subjects = survey_subjects(survey, student)

    render json: build_survey(survey, survey_subjects), status: :ok
  rescue SurveySubmissions::ExpiredSurveyPeriodError
    no_active_survey
  end

  def edit
    survey = survey_submissions.current_survey
    answers = survey_submissions.obtain_answers(survey_submissions.current_survey, student)
    head(:not_found) && return if answers.empty?

    render json: build_editable_survey(answers, survey_subjects(survey, student), survey), status: :ok
  rescue SurveySubmissions::ExpiredSurveyPeriodError
    no_active_survey
  end

  def update
    survey = survey_submissions.find_survey(survey_args[:surveyId])
    survey_submissions.update_answers(student, survey, survey_args[:subjects])

    head :ok
  rescue SurveySubmissions::INVALID_ANSWER
    invalid_chair
  end

  private

  def survey_args
    params.permit(:surveyId, subjects: %i[name selectedChair])
  end

  def survey_submissions
    @submissions ||= SurveySubmissions.new
  end

  def student
    token = params[:token] || params[:id]
    @student ||= Student.includes(:subjects).find_by!(token: token)
  end

  def survey_subjects(survey, student)
    survey_submissions.last_survey_subjects(survey, student)
  end

  def no_active_survey
    render json: { msg: 'No se pudo encontrar la encuesta' }, status: :not_found
  end

  def invalid_chair
    render json: { msg: 'Ha seleccionado una catedra invalida' }, status: :bad_request
  end
end
