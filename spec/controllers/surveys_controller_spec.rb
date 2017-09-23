require 'rails_helper'

describe SurveysController do
  context 'POST #create' do
    it 'returns a 200 status code' do
      post :create

      expect(response.status).to eq 200
    end
  end
end
