class SigninController < ApplicationController
  def show
    student = academic_record.find_student_with(token: params[:id])

    render json: { token: student.token }, status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end
end
