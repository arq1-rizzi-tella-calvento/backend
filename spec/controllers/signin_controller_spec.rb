require 'rails_helper'

describe SigninController do
  describe 'GET /signin' do
    let(:student) { create :student }
    subject { get :index }

    before { request.headers['Token'] = token }

    context 'when there is no user for the given token' do
      let(:token) { 'non-existing-token' }

      it 'returns a not found error' do
        subject

        expect(response.status).to eq 404
      end
    end

    context 'when the student exists' do
      let(:token) { student.token }

      it 'returns the student id when the student exists' do
        subject

        expect(response_body[:token]).to eq student.token
        expect(response_body[:name]).to eq student.name
        expect(response_body[:identity_document]).to eq student.identity_document
      end
    end
  end
end
