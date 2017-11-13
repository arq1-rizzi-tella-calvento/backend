class SigninController < ApplicationController
  def show
    student = Student.select(:id).find_by!(identity_document: args[:id])

    render json: { student_id: student.id }, status: :ok

  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def args
    params.permit(:id)
  end
end