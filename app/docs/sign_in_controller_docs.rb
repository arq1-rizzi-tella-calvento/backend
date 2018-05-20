module SignInControllerDocs
  extend Apipie::DSL::Concern

  api :GET, '/signin', 'Obtiene la informacion del estudiante'
  header :token, 'Token que autentica al estudiante', required: true
  error code: 404, desc: 'El token no esta asociado a ningun estudiante'
  returns code: 200, desc: 'Respuesta exitosa' do
    property :token, String, desc: 'Token del estudiante'
    property :name, String, desc: 'Nombre del estudiante'
    property :identity_document, Integer, desc: 'Numero de documento del estudiante'
  end
  formats %w[json]
  def index; end
end
