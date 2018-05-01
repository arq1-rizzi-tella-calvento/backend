class SigninController < ApplicationController

  api :GET, '/signin/:id', 'Obtiene la informacion del estudiante'
  param :id, String, required: true, desc: 'Token que autentica al estudiante'
  error code: 404, desc: 'El token no esta asociado a ningun estudiante'
  returns code: 200, desc: 'Respuesta exitosa' do
    property :token, String, desc: 'Token del estudiante'
    property :name, String, desc: 'Nombre del estudiante'
    property :identity_document, Integer, desc: 'Numero de documento del estudiante'
  end
  formats %w[json]
  def index
    student = academic_record.find_student_with(token: request.headers['Token'])

    render json: { token: student.token, name: student.name, identity_document: student.identity_document }, status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
