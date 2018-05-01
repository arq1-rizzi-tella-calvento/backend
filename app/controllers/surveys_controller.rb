class SurveysController < ApplicationController
  include SurveyService

  rescue_from ActiveRecord::RecordNotFound, with: -> { head :unauthorized }

  def_param_group :survey do
    property :survey, Hash, desc: 'Encuesta a completar' do
      property :subjects, Array, desc: 'Materias' do
        property :subject, Hash, desc: 'Encuesta' do
          property :name, String, desc: 'Nombre de la materia'
          property :id, Integer, desc: 'ID de la materia'
          property :chairs, Array, desc: 'Catedras de la materia' do
            property :id, Integer, desc: 'Id de la comision'
            property :selected, String, desc: 'Catedra seleccionada por el usuario'
            property :time, String, desc: 'Horario de la comision'
          end
        end
      end
      property :survey_id, Integer, desc: 'Id de la encuesta'
    end
  end

  def_param_group :survey_response do
    property :survey_response, Hash, desc: 'Informacion de la encuesta' do
      property :subjects, Array, desc: 'Porcentajes de ocupacion de comisiones' do
        property :subject, Hash, desc: 'Descripcion de la materia en la que fue inscripto' do
          property :subject_name, String, desc: 'Nombre de la materia'
          property :time, String, desc: 'Horario de la comision'
        end
      end

      property :link, String, desc: 'Link para editar la encuesta'
    end
  end

  api :POST, '/survey', 'Completar una encuesta'
  returns :survey_response, code: 200
  error code: 400, desc: 'Selecciono un ID de catedra invalido'
  error code: 400, desc: 'El alumno ya realizo una encuesta, debe editar la que ya existe'
  formats %w[json]
  def create
    survey = survey_submissions.find_survey(survey_args[:id])
    answers = survey_submissions.create_answers(student, survey, survey_args[:subjects])

    render json: generate_survey_response(answers, student), status: :ok
  rescue SurveySubmissions::INVALID_ANSWER
    invalid_chair
  rescue SurveySubmissions::InvalidSurveyActionError
    invalid_survey_action 'Usted ya completo la encuesta, por favor use el link de editar'
  end

  api :GET, '/surveys/:token/new', 'Informacion para crear una nueva encuesta'
  param :token, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 404, desc: 'No hay ninguna encuesta activa'
  returns :survey, code: 200
  formats %w[json]
  def new
    survey = survey_submissions.current_survey
    survey_subjects = survey_subjects(survey, student)

    render json: build_survey(survey, survey_subjects), status: :ok
  rescue SurveySubmissions::ExpiredSurveyPeriodError
    no_active_survey
  end

  api :GET, '/surveys/:id/edit', 'Informacion para editar una encuesta existente'
  param :id, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 404, desc: 'No hay ninguna encuesta activa'
  returns :survey, code: 200
  formats %w[json]
  def edit
    survey = survey_submissions.current_survey
    answers = survey_submissions.obtain_answers(survey, student)

    render json: build_editable_survey(answers, survey_subjects(survey, student), survey), status: :ok
  rescue SurveySubmissions::ExpiredSurveyPeriodError
    no_active_survey
  end

  api :PUT, '/surveys/:id', 'Actualizar una encuesta'
  param :id, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 400, desc: 'Selecciono un ID de catedra invalido'
  error code: 404, desc: 'No hay ninguna encuesta activa'
  returns :survey_response, code: 200
  formats %w[json]
  def update
    survey = survey_submissions.find_survey(survey_args[:id])
    answers = survey_submissions.update_answers(student, survey, survey_args[:subjects])

    render json: generate_survey_response(answers, student), status: :ok
  rescue SurveySubmissions::INVALID_ANSWER
    invalid_chair
  rescue SurveySubmissions::ExpiredSurveyPeriodError
    no_active_survey
  end

  private

  def survey_args
    params.permit(:id, subjects: %i[name selected])
  end

  def survey_submissions
    @submissions ||= SurveySubmissions.new
  end

  def student
    token = request.headers['Token']
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

  def invalid_survey_action(msg)
    render json: { msg: msg }, status: :bad_request
  end
end
