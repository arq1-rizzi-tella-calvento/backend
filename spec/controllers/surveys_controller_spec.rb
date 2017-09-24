require 'rails_helper'

describe SurveysController do
  context 'POST #create' do
    it 'returns a 200 status code' do
      post :create

      expect(response.status).to eq 200
    end
  end

  context 'GET #new' do
    let(:expected_response) do
      {
        '1' => ['c1', 'c2', 'no-cursar', 'ya-curso'],
        '2' => ['c1', 'c2', 'no-cursar', 'ya-curso'],
        '3' => ['c1', 'no-cursar', 'ya-curso'],
      }
    end

    it 'returns the questions' do
      get :new

      expect(JSON.parse(response.body)).to eq expected_response
    end
  end
end
