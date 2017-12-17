class SigninController < ApplicationController
  def show
    student = academic_record.find_student_with(token: params[:id])

    render json: { token: student.token, name: student.name, identity_document: student.identity_document }, status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
