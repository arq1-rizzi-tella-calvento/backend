require 'rails_helper'

describe SignupController do
  describe 'GET /signup/subjects' do
    it 'Returns a list of subjects' do
      expected_subjects_data = (1..2).map do
        subject = create(:subject)
        [subject.name, subject.id]
      end

      get :subjects

      expect(response_body).to match_array(expected_subjects_data)
    end
  end

  describe 'POST /signup' do
    let(:student) do
      { name: 'Roman Rizzi', email: 'testEmail@mail.com', identity_document: 38_394_032 }
    end
    let(:bad_request) { 400 }
    let(:ok) { 200 }
    let(:nonexistent_subject_id) { 999 }
    let(:valid_subject_id) { create(:subject).id }

    it 'Returns a 400 when there a nonexistent subject is given' do
      invalid_student = student_with_subjects [nonexistent_subject_id]

      post :create, params: invalid_student

      missing_subject_response
    end

    it 'Returns a 200 and the student id when everything is OK' do
      valid_student = student_with_subjects [valid_subject_id]

      post :create, params: valid_student

      expect(response.status).to eq ok
      expect(response_body[:student_id]).to be_present
    end

    it 'Returns a 400 when one of the subjects does not exist' do
      mixed_subjects = [valid_subject_id, nonexistent_subject_id]
      invalid_student = student_with_subjects mixed_subjects

      post :create, params: invalid_student

      missing_subject_response
    end

    it 'Returns a 400 when the identity document is duplicated' do
      duplicated_identity_document = 38_546_444
      create(:student, identity_document: duplicated_identity_document)
      repeated_student = student.dup.tap { |student| student[:identity_document] = duplicated_identity_document }

      post :create, params: repeated_student

      expect(response.status).to eq bad_request
      expect(response_body[:message]).to eq 'Validation failed: Identity document has already been taken'
    end

    def missing_subject_response
      expect(response.status).to eq bad_request
      expect(response_body[:message]).to eq 'Nonexistent subject'
    end

    def student_with_subjects(subjects)
      student.dup.tap { |student| student[:subjects] = subjects }
    end
  end
end
