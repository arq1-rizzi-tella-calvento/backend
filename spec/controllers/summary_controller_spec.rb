require 'rails_helper'

describe SummaryController do
  context '#summary' do
    let(:survey) { create :survey }
    let(:math_subject) { create :subject_in_quarter, survey: survey }
    let!(:chair_1) { create :chair, number: 1, subject_in_quarter: math_subject }
    let(:intro) { create(:subject_in_quarter, subject: create(:subject, name: 'Intro'), survey: survey) }
    let!(:intro_chair_2) { create :chair, number: 2, subject_in_quarter: intro }
    let!(:intro_chair_1) { create :chair, number: 1, subject_in_quarter: intro }
    let(:chairs) { [chair_1, intro_chair_1, intro_chair_2] }

    it 'returns the subject name, chair, number of students and fullness percentage' do
      expected_response = chairs.map do |chair|
        {
          name: chair.subject.name,
          chair: chair.number,
          number_of_students: chair.number_of_students,
          fullness_percentage: chair.fullness_percentage
        }
      end

      get :index

      expect(response_body[:subjects]).to eq expected_response
    end

    it 'returns the percentage of students that answered the survey' do
      2.times { create :student }
      2.times { create :answer, survey: survey, chair: chair_1 }
      create :answer, survey: survey, chair: intro_chair_1, student: Answer.first.student

      get :index

      expect(response_body[:answers_percentage]).to eq 50
    end
  end
end
