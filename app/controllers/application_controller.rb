class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  private

  def academic_record
    @academic_record ||= AcademicRecord.new
  end
end
