require 'rails_helper'

describe SurveysController do
  let(:student) { create(:student) }

  context 'POST #create' do
    let(:subjects) { [{ name: create(:subject).name, chairs: [], selectedChair: 'cant' }] }

    it 'returns a 200 status code' do
      post :create, params: { subjects: subjects, userId: student.token }

      expect(response.status).to eq 200
    end

    it 'creates an Answer per subject ' do
      expect { post :create, params: { subjects: subjects, userId: student.token } }
        .to change { Answer.count }.by(subjects.count)
    end
  end

  before do
    @a_chair = create(:chair)
    @a_second_chair = create(:chair)
    subject_in_quarter = create(:subject_in_quarter, chairs: [@a_chair, @a_second_chair])

    @a_subject = create(:subject, subject_in_quarter: subject_in_quarter)
    @a_survey = create(:survey, subjects: [@a_subject])
  end

  context 'GET #new' do
    it 'Returns the subjects with their chairs' do
      get_new_survey student

      survey_subject = response_body.detect { |subject| subject[:name] == @a_subject.name }
      expect(survey_subject[:chairs]).to match_array [@a_chair.time, @a_second_chair.time]
    end

    it 'Only returns the subjects that the student hasnt approved yet' do
      student_with_approved_subjects = create(:student, subjects: [@a_subject])

      get_new_survey student_with_approved_subjects

      expect(response_body).to be_empty
    end

    it 'Returns a not found when the student is unknown' do
      unexistent_student_id = Student.new(token: 4000)

      get_new_survey unexistent_student_id

      expect(response.status).to eq 404
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
      create(:answer, survey: @a_survey, chair: @a_chair, student: student)

      get :edit, params: { id: student.token }
      survey_subject = response_body.detect { |subject| subject[:name] == @a_subject.name }

      expect(survey_subject[:selected]).to eq @a_chair.time
    end
  end

  context 'POST #update' do
    it 'Returns a 401 when the student is unknown' do
      unknown_student_token = 'a_token'

      put :update, params: { id: unknown_student_token }

      expect(response.status).to eq 401
    end

    it 'Updates existing answers from a student' do
      answer = create(:answer, survey: @a_survey, chair: @a_chair, student: student)
      updated_answers = [{ name: @a_chair.subject.name, selectedChair: @a_second_chair.id }]

      put :update, params: { id: student.token, subjects: updated_answers }

      expect(answer.reload.chair_id).to eq @a_second_chair.id
    end
  end
end
