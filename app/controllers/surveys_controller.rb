class SurveysController < ApplicationController
  def create
    rand
    render json: { message: 'Survey successfully submitted' }, status: :ok
  end

  def new
    common_options = ['Ya curse', 'Todavia no voy a cursar']
    survey.each { |question| question[:options].concat(common_options) }

    render json: survey, status: :ok
  end

  private

  def survey
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
end
