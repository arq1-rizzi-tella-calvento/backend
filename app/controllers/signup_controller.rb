class SignupController < ApplicationController
  INVALID_SUBJECT_SELECTION = Class.new(StandardError)

  def subjects
    render json: Subject.pluck(:name, :id)
  end

  def create
    created_student = AcademicRecord.new.enroll_student(student, approved_subjects)
    render json: { student_id: created_student.id }, status: :ok
  rescue INVALID_SUBJECT_SELECTION, ActiveRecord::RecordInvalid => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def student_params
    params.permit(:name, :email, :identity_document, subjects: [])
  end

  def student
    Student.new(student_params.except(:subjects))
  end

  def approved_subjects
    Subject.where(id: student_params[:subjects]).tap do |subjects|
      if subjects.size < student_params[:subjects].to_a.size
        raise INVALID_SUBJECT_SELECTION, 'Nonexistent subject'
      end
    end
  end
end