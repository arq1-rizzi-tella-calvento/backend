require 'rails_helper'

describe SigninController do
  describe 'GET /signin' do
    let(:identity_document) { 38_456_789 }

    it 'Returns a not found when there is no user with that identity document' do
      get :show, params: { id: identity_document }

      expect(response.status).to eq 404
    end

    it 'Returns the student id when the student exists' do
      existing_student = create(:student, identity_document: identity_document)

      get :show, params: { id: identity_document }

      expect(response_body[:student_id]).to eq existing_student.id
    end
  end
end
