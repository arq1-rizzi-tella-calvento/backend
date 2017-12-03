class SignupController < ApplicationController
  INVALID_SUBJECT_SELECTION = Class.new(StandardError)

  def subjects
    render json: Subject.pluck(:name, :id)
  end

  def create
    created_student = academic_record.enroll_student(student, approved_subjects)

    render json: { student_id: created_student.id }, status: :ok
  rescue INVALID_SUBJECT_SELECTION, ActiveRecord::RecordInvalid => e
    render_error_response(e.message)
  rescue ActiveRecord::RecordNotFound
    render_error_response('Invalid token')
  end

  private

  def render_error_response(error_message)
    render json: { message: error_message }, status: :bad_request
  end

  def student_params
    params.permit(:name, :identity_document, :token, subjects: [])
  end

  def student
    current_student = Student.find_by!(token: student_params[:token])
    current_student.assign_attributes(student_params.except(:subjects, :token))

    current_student
  end

  def approved_subjects
    Subject.where(id: student_params[:subjects]).tap do |subjects|
      if subjects.size < student_params[:subjects].to_a.size
        raise INVALID_SUBJECT_SELECTION, 'Nonexistent subject'
      end
    end
  end
end
