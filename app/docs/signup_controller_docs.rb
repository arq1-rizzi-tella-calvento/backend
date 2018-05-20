module SignupControllerDocs
  extend Apipie::DSL::Concern

  api :GET, '/signup/subjects', 'Obtiene la informacion de las materias'
  returns code: 200, desc: 'Respuesta exitosa' do
    property :subjects, Array, desc: 'List de materias' do
      property :subject, Array, desc: 'Materia' do
        property :name, String, desc: 'Nombre de la materia'
        property :id, Integer, desc: 'ID de la materia'
      end
    end
  end
  formats %w[json]
  def subjects; end

  api :POST, '/signup', 'Asigna las materias aprobadas de un estudiante, asociandolas'
  error code: 400, desc: 'El token no esta asociado a ningun estudiante'
  error code: 400, desc: 'Hay ids de materias que no son validos'
  returns code: 200, desc: 'Respuesta exitosa' do
    property :token, String, desc: 'Token del estudiante'
  end
  formats %w[json]
  def create; end
end
