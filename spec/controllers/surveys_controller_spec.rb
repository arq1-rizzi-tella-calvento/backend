require 'rails_helper'
include SurveyService

describe SurveysController do
  let(:subject_in_quarter) { build(:subject_in_quarter, survey: survey) }
  let(:student) { create(:student) }
  let(:chair) { build(:chair, subject_in_quarter: subject_in_quarter) }
  let(:second_chair) { build(:chair, subject_in_quarter: subject_in_quarter) }
  let(:survey) { build(:survey) }
  let!(:subject) { create(:subject, subject_in_quarter: subject_in_quarter) }

  before do
    subject_in_quarter.chairs = [chair, second_chair]
  end

  context 'POST #create' do
    let(:subjects) { [{ name: create(:subject).name, chairs: [], selectedChair: Answer::NOT_THIS_QUARTER }] }
    let(:survey) { create :survey }
    let(:chair) { create(:chair, subject_in_quarter: create(:subject_in_quarter, survey: survey)) }
    let(:other_subjects) { [{ name: create(:subject).name, chairs: [chair], selectedChair: chair.id }] }

    it 'returns a 200 status code' do
      post :create, params: { subjects: subjects, userId: student.token }

      expect(response.status).to eq 200
    end

    it 'creates no Answer because the student doesnt select chairs' do
      expect { post :create, params: { subjects: subjects, userId: student.token } }
        .to change { Answer.count }.by(0)
    end

    it 'creates an Answer per subject' do
      expect { post :create, params: { subjects: other_subjects, userId: student.token } }
        .to change { Answer.count }.by(other_subjects.count)
    end
  end

  context 'GET #new' do
    it 'Returns the subjects with their chairs' do
      get_new_survey student

      survey_subject = response_body.detect { |a_subject| a_subject[:name] == subject.name }
      expect(
        survey_subject[:chairs]
      )
        .to match_array [
          { id: chair.id, time: chair_description(chair) },
          { id: second_chair.id, time: chair_description(second_chair) }
        ]
    end

    it 'Only returns the subjects that the student hasnt approved yet' do
      student_with_approved_subjects = create(:student, subjects: [subject])

      get_new_survey student_with_approved_subjects

      expect(response_body).to be_empty
    end

    it 'Returns a not found when the student is unknown' do
      unexistent_student_id = Student.new(token: 4000)

      get_new_survey unexistent_student_id

      expect(response.status).to eq 404
    end

    context 'when the survey submission period has finished' do
      let(:survey) { build :survey, :ended }

      it 'returns a bad request' do
        get_new_survey student

        expect(response.status).to eq 404
      end
    end

    def get_new_survey(student)
      get :new, params: { token: student.token }
    end
  end

  context 'GET #edit' do
    it 'Returns a 404 when there is no submitted survey' do
      get :edit, params: { id: student.token }

      expect(response.status).to eq 404
    end

    it 'Returns a 401 when the student is unknown' do
      unknown_student_token = 'a_token'

      get :edit, params: { id: unknown_student_token }

      expect(response.status).to eq 401
    end

    it 'Returns a new survey with the previously selected options' do
      create(:answer, survey: survey, chair: chair, student: student)

      get :edit, params: { id: student.token }
      survey_subject = response_body.detect { |a_subject| a_subject[:name] == subject.name }

      expect(survey_subject[:selected]).to eq chair.id
    end
  end

  context 'POST #update' do
    it 'Returns a 401 when the student is unknown' do
      unknown_student_token = 'a_token'

      put :update, params: { id: unknown_student_token }

      expect(response.status).to eq 401
    end

    it 'Updates existing answers from a student' do
      answer = create(:answer, survey: survey, chair: chair, student: student)
      updated_answers = [{ name: chair.subject.name, selectedChair: second_chair.id }]

      put :update, params: { id: student.token, subjects: updated_answers }

      expect(answer.reload.chair_id).to eq second_chair.id
    end
  end
end
