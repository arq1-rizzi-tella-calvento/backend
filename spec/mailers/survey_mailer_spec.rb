require 'rails_helper'

RSpec.describe SurveyMailer, type: :mailer do
  context '#survey' do
    let!(:survey) { create :survey }
    let(:student) { create :student }
    let(:survey_email) { subject.survey student }

    it 'sends the email to every student' do
      expect(survey_email.to).to eq [student.email]
    end

    it 'includes the subject' do
      expect(survey_email.subject).to eq "Encuesta de pre-inscripción cuatrimestre #{survey.quarter}"
    end

    it 'includes the link and the survey active period in the body' do
      expect(survey_email.body).to include "#{subject.url_options[:host]}/#{student.token}"
      expect(survey_email.body).to include survey.end_date.strftime('%d/%m')
    end
  end
end
