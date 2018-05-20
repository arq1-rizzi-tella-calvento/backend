module SummaryControllerDocs
  extend Apipie::DSL::Concern

  api :GET, '/summary', 'Informacion de la estadistica de la encuesta'
  returns code: 200, desc: 'Respuesta exitosa' do
    property :summary, Hash, desc: 'Estadisticas' do
      property :subjects, Array, desc: 'Porcentajes de ocupacion de comisiones' do
        property :subject_summary, Hash, desc: 'Datos de una materia en particular' do
          property :name, String, desc: 'Nombre de la materia'
          property :summary, Hash, desc: 'Informacion' do
            property :chair, Integer, desc: 'ID de la catedra'
            property :number_of_students, Integer, desc: 'Numero de estudiantes anotados'
            property :fullness_percentage, Float, desc: 'Porcentaje de ocupacion'
          end
        end
      end

      property :answers_percentage, Float, desc: 'Porcentaje de respuestas sobre cantidad de alumnos'
    end
  end
  formats %w[json]
  def index; end
end
