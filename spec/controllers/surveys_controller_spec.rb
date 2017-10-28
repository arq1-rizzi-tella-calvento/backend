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
      [
        {
          name: 'Estructura de datos',
          options: ['C1 - 21-22hs Miercoles', 'C2 - 21-22hs Jueves']
        },
        {
          name: 'Matematica II',
          options: ['C1 - 8-12hs Viernes', 'C2 - 8-12hs Lunes']
        },
        {
          name: 'Ingles I',
          options: ['C1 - 14-16hs Jueves', 'C2 - 14-16hs Martes']
        },
        {
          name: 'Programación concurrente',
          options: ['C1 - 18-22hs Martes', 'C2 - 18-22hs Viernes']
        }
      ]
    end

    it 'returns the questions' do
      get :new

      survey = JSON.parse(response.body, symbolize_names: true)

      expect(survey).to eq expected_response
    end

    def commission(name, schedule, day)
      { name: name, class_schedule: schedule, day: day }
    end
  end
end
