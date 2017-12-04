require 'rails_helper'

describe SigninController do
  describe 'GET /signin' do
    let(:student) { create :student }

    it 'returns a not found error when there is no user with the given token' do
      get :show, params: { id: 'non-existing-token' }

      expect(response.status).to eq 404
    end

    it 'returns the student id when the student exists' do
      get :show, params: { id: student.token }

      expect(response_body[:student_id]).to eq student.id
    end
  end
end
