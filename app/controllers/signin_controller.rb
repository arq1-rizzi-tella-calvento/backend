class SigninController < ApplicationController
  include SignInControllerDocs

  def index
    student = academic_record.find_student_with(token: request.headers['Token'])

    render json: { token: student.token, name: student.name, identity_document: student.identity_document }, status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
