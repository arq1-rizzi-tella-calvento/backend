require 'rails_helper'

describe SurveySubmissions do
  let(:student) { create(:student) }
  let(:survey) { create(:survey) }
  it 'Returns an empty list when the student didnt submit a survey' do
    answers = subject.obtain_answers(survey, student)

    expect(answers).to be_empty
  end

  it 'Returns the answers previously submitted' do
    answer = create(:answer, survey: survey, student: student, chair: build(:chair))

    answers = subject.obtain_answers(survey, student)

    expect(answers).to match_array [answer]
  end

  it 'Filters out the answers from another survey' do
    another_survey = create(:survey)
    create(:answer, survey: another_survey, student: student, chair: build(:chair))

    answers = subject.obtain_answers(survey, student)

    expect(answers).to be_empty
  end
end
