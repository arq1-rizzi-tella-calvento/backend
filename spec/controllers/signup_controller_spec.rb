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
    let!(:student) { create :student, email: 'testEmail@mail.com' }
    let(:student_params) do
      { name: 'Roman Rizzi', identity_document: 38_394_032, token: student.token }
    end
    let(:bad_request) { 400 }
    let(:ok) { 200 }
    let(:nonexistent_subject_id) { 999 }
    let(:valid_subject_id) { create(:subject).id }

    it 'Returns a 200 and the student id when everything is OK' do
      student_with_subjects [valid_subject_id]

      post :create, params: student_params

      student.reload
      expect(response.status).to eq ok
      expect(response_body[:token]).to eq student.token
      expect(student.name).to eq student_params[:name]
      expect(student.identity_document).to eq student_params[:identity_document]
    end

    context 'unsuccessful response' do
      it 'returns a 400 when there a nonexistent subject is given' do
        invalid_student = student_with_subjects [nonexistent_subject_id]

        post :create, params: invalid_student

        assert_it_returns_a_missing_subject_response
      end

      it 'returns a 400 when one of the subjects does not exist' do
        mixed_subjects = [valid_subject_id, nonexistent_subject_id]
        invalid_student = student_with_subjects mixed_subjects

        post :create, params: invalid_student

        assert_it_returns_a_missing_subject_response
      end

      it 'returns a 400 when the identity document is duplicated' do
        duplicated_identity_document = 38_546_444
        create(:student, identity_document: duplicated_identity_document)
        repeated_student = student_params.dup.tap do |student|
          student[:identity_document] = duplicated_identity_document
        end

        post :create, params: repeated_student

        assert_it_returns_a_bad_request_response
        assert_response_contains_message 'Validation failed: Identity document has already been taken'
      end

      it 'returns a 400 when there is no student with the given token' do
        post :create, params: student_params.merge(token: 'non-existent-token')

        assert_it_returns_a_bad_request_response
        assert_response_contains_message 'Invalid token'
      end
    end

    def assert_response_contains_message(string)
      expect(response_body[:message]).to eq string
    end

    def assert_it_returns_a_bad_request_response
      expect(response.status).to eq bad_request
    end

    def assert_it_returns_a_missing_subject_response
      assert_it_returns_a_bad_request_response
      assert_response_contains_message 'Nonexistent subject'
    end

    def student_with_subjects(subjects)
      student_params.dup.tap { |student| student[:subjects] = subjects }
    end
  end
end
