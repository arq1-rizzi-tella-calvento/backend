require 'rails_helper'

describe SurveysController do
  context 'POST #create' do
    let(:subjects) do
      [{ name: 'Subject test', chairs: [], selectedChair: 'cant' }]
    end
    let(:student) do
      Student.create(name: 'Roman Rizzi', email: 'testEmail@mail.com', identity_document: 38_394_032)
    end

    it 'returns a 200 status code' do
      post :create, params: { subjects: subjects, userId: student.id }

      expect(response.status).to eq 200
    end

    it 'creates an Answer per subject ' do
      expect { post :create, params: { subjects: subjects, userId: student.id } }
        .to change { Answer.count }.by(subjects.count)
    end
  end

  context 'GET #new' do
    before do
      @a_chair = create(:chair)
      subject_in_quarter = create(:subject_in_quarter, chairs: [@a_chair])

      @a_subject = create(:subject, subject_in_quarter: subject_in_quarter)
      create(:survey, subjects: [@a_subject])
    end

    it 'Returns the subjects with their chairs' do
      first_semester_student = create(:student)

      get :new, params: { student_id: first_semester_student.id }
      survey_subject = response_body.detect { |subject| subject[:name] == @a_subject.name }

      expect(survey_subject[:chairs]).to match_array [@a_chair.time]
    end

    it 'Only returns the subjects that the student hasnt approved yet' do
      student_with_approved_subjects = create(:student, subjects: [@a_subject])

      get :new, params: { student_id: student_with_approved_subjects.id }

      expect(response_body).to be_empty
    end

    it 'Returns a not found when the student is unknown' do
      unexistent_student_id = 4000

      get :new, params: { student_id: unexistent_student_id }

      expect(response.status).to eq 404
    end
  end
end
