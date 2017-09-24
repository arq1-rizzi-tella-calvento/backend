class SurveysController < ApplicationController
  def create
    render json: {}, status: :ok
  end

  def new
    survey = {
      1 => ['c1', 'c2', 'no-cursar', 'ya-curso'],
      2 => ['c1', 'c2', 'no-cursar', 'ya-curso'],
      3 => ['c1', 'no-cursar', 'ya-curso'],
    }

    render json: survey, status: :ok
  end
end
