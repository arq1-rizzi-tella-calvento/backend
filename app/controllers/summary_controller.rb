class SummaryController < ApplicationController
  def index
    render json: {
      subjects: academic_record.survey_summary, answers_percentage: academic_record.answers_percentage
    }, status: :ok
  end
end
