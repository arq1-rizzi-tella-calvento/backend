require 'rails_helper'

describe SurveysController do
  context 'POST #create' do
    let(:subjects) do
      [{ name: create(:subject).name, chairs: [], selectedChair: 'cant' }]
    end
    let(:student) do
      Student.create(name: 'Roman Rizzi', email: 'testEmail@mail.com', identity_document: 38_394_032, token: 4000)
    end

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
      first_semester_student = create(:student)

      get_new_survey first_semester_student

      survey_subject = response_body.detect { |subject| subject[:name] == @a_subject.name }
      expect(survey_subject[:chairs]).to match_array [{ id: @a_chair.id, time: @a_chair.time }]
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
      student = create(:student)

      get :edit, params: { id: student.token }

      expect(response.status).to eq 404
    end

    it 'Returns a 401 when the student is unknown' do
      unknown_student_token = 'a_token'

      get :edit, params: { id: unknown_student_token }

      expect(response.status).to eq 401
    end

    it 'Returns a new survey with the previously selected options' do
      student = create(:student)
      create(:answer, survey: @a_survey, chair: @a_chair, student: student)

      get :edit, params: { id: student.token }
      survey_subject = response_body.detect { |subject| subject[:name] == @a_subject.name }

      expect(survey_subject[:selected]).to eq @a_chair.time
    end
  end
end
