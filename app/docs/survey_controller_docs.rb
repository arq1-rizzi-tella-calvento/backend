module SurveyControllerDocs
  extend Apipie::DSL::Concern

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
  def create; end

  api :GET, '/surveys/:token/new', 'Informacion para crear una nueva encuesta'
  param :token, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 404, desc: 'No hay ninguna encuesta activa'
  returns :survey, code: 200
  formats %w[json]
  def new; end

  api :GET, '/surveys/:id/edit', 'Informacion para editar una encuesta existente'
  param :id, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 404, desc: 'No hay ninguna encuesta activa'
  returns :survey, code: 200
  formats %w[json]
  def edit; end

  api :PUT, '/surveys/:id', 'Actualizar una encuesta'
  param :id, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 400, desc: 'Selecciono un ID de catedra invalido'
  error code: 404, desc: 'No hay ninguna encuesta activa'
  returns :survey_response, code: 200
  formats %w[json]
  def update; end
end
