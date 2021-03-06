require 'rails_helper'

describe SurveysController do
  include SurveyService

  let(:subject_in_quarter) { build(:subject_in_quarter, survey: survey) }
  let(:student) { create(:student) }
  let(:chair) { create(:chair, subject_in_quarter: subject_in_quarter) }
  let(:second_chair) { create(:chair, subject_in_quarter: subject_in_quarter) }
  let(:survey) { create(:survey) }
  let!(:subject) { create(:subject, subject_in_quarter: subject_in_quarter) }

  before do
    self.headers_token = student.token
    subject_in_quarter.chairs = [chair, second_chair]
  end

  context 'POST #create' do
    let(:subjects) { [{ name: create(:subject).name, chairs: [], selectedChair: Answer::NOT_THIS_QUARTER }] }
    let(:other_subjects) { [{ name: create(:subject).name, chairs: [chair], selected: chair.id }] }
    let(:survey_payload) { { subjects: subjects, id: survey.id } }

    it 'creates no Answer because the student doesnt select chairs' do
      expect { post :create, params: survey_payload }.to change { Answer.count }.by(0)
    end

    it 'creates an Answer per subject' do
      expect { post :create, params: survey_payload.merge(subjects: other_subjects) }
        .to change { Answer.count }.by(other_subjects.count)
    end

    it 'Prevents the same student from submitting the survey twice' do
      create(:answer, survey: survey, chair: chair, student: student)
      new_answers = [{ name: chair.subject.name, selected: second_chair.id }]

      post :create, params: survey_payload.merge(subjects: new_answers)

      expect(response.status).to eq 400
    end
  end

  context 'GET #new' do
    it 'Returns the subjects with their chairs' do
      get_new_survey student

      survey_subject = response_body[:subjects].detect { |a_subject| a_subject[:name] == subject.name }
      expect(survey_subject[:chairs]).to match_array [
        { id: chair.id, time: chair_description(chair) }, { id: second_chair.id, time: chair_description(second_chair) }
      ]
    end

    it 'Only returns the subjects that the student hasnt approved yet' do
      student_with_approved_subjects = create(:student, subjects: [subject])

      get_new_survey student_with_approved_subjects

      expect(response_body[:subjects]).to be_empty
    end

    it 'Returns an unauthorized error when the student is unknown' do
      unexistent_student_id = Student.new(token: 4000)

      get_new_survey unexistent_student_id

      expect(response.status).to eq 401
    end

    it 'The survey id is retrieved for a survey' do
      get_new_survey student

      expect(response_body[:survey_id]).to eq survey.id
    end

    context 'when the survey submission period has finished' do
      let(:survey) { build :survey, :ended }

      it 'returns a bad request' do
        get_new_survey student

        expect(response.status).to eq 404
      end
    end

    def get_new_survey(student)
      self.headers_token = student.token
      get :new
    end
  end

  context 'GET #edit' do
    it 'Returns a 401 when the student is unknown' do
      self.headers_token = 'a_token'

      get :edit

      expect(response.status).to eq 401
    end

    it 'Returns a new survey with the previously selected options' do
      create(:answer, survey: survey, chair: chair, student: student)

      get :edit
      survey_subject = response_body[:subjects].detect { |a_subject| a_subject[:name] == subject.name }

      expect(survey_subject[:selected]).to eq chair.id
    end

    it 'Returns the survey id' do
      create(:answer, survey: survey, chair: chair, student: student)

      get :edit, params: { id: student.token }

      expect(response_body[:survey_id]).to eq survey.id
    end
  end

  context 'POST #update' do
    it 'Returns a 401 when the student is unknown' do
      self.headers_token = 'a_token'

      put :update, params: { id: survey.id }

      expect(response.status).to eq 401
    end

    it 'Updates existing answers from a student' do
      answer = create(:answer, survey: survey, chair: chair, student: student)
      updated_answers = [{ name: chair.subject.name, selected: second_chair.id }]

      put :update, params: { id: survey.id, subjects: updated_answers }

      expect(answer.reload.chair_id).to eq second_chair.id
    end
  end

  def headers_token=(token)
    request.headers['Token'] = token
  end
end
