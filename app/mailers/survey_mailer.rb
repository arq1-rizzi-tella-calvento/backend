class SurveyMailer < ApplicationMailer
  def survey(student)
    @student = student
    @survey = Survey.last

    mail to: @student.email, subject: "Encuesta de pre-inscripción cuatrimestre #{@survey.quarter}" do |format|
      format.html { render 'survey' }
    end
  end
end
