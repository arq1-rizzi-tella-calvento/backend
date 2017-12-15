require 'rails_helper'

describe SurveySubmissions do
  let(:student) { create(:student) }
  let(:survey) { create(:survey) }

  describe 'Obtaining the answers of a student' do
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

  describe 'Updating the answers of an existing survey' do
    let(:chair) { create(:chair) }

    it 'When there is no selection made, we DO NOT update the answer' do
      answer = create(:answer, survey: survey, student: student, chair: chair)
      answer_attributes = [build_updated_answer(chair.subject_name, nil)]

      subject.update_answers(student, survey, answer_attributes)

      expect(answer.reload.chair_id).to eq chair.id
    end

    it 'When the selection is an invalid chair id, we raise an error' do
      unknown_chair_id = 9999
      create(:answer, survey: survey, student: student, chair: chair)
      answer_attributes = [build_updated_answer(chair.subject_name, unknown_chair_id)]

      expect do
        subject.update_answers(student, survey, answer_attributes)
      end.to raise_error described_class::INVALID_ANSWER
    end

    it 'When there are no updated answers, we do nothing' do
      answer = create(:answer, survey: survey, student: student, chair: chair)
      answer_attributes = []

      subject.update_answers(student, survey, answer_attributes)

      expect(answer.reload.chair_id).to eq chair.id
    end

    it 'Changes the answer with a chair from a reply option destroying it' do
      reply_option = create(:reply_option, subject: chair.subject)
      answer = create(:answer, survey: survey, student: student, reply_option: reply_option)
      answer_attributes = [build_updated_answer(chair.subject_name, chair.id)]

      subject.update_answers(student, survey, answer_attributes)

      expect(answer.reload.chair_id).to eq chair.id
      expect(answer.reload.reply_option).to be_nil
    end

    it 'Changes the answer from a chair to a reply option' do
      answer = create(:answer, survey: survey, student: student, chair: chair)
      answer_attributes = [build_updated_answer(chair.subject_name, Answer::SCHEDULE_PROBLEM)]

      subject.update_answers(student, survey, answer_attributes)

      expect(answer.reload.chair).to be_nil
      expect(answer.reload.reply_option).to be_present
    end

    it 'When the answer changes to dont, we delete the answer' do
      create(:answer, survey: survey, student: student, chair: chair)
      answer_attributes = [build_updated_answer(chair.subject_name, Answer::NOT_THIS_QUARTER)]

      expect { subject.update_answers(student, survey, answer_attributes) }.to change { Answer.count }.to 0
    end

    it 'When the answer is not registered, we create a new one' do
      answer_attributes = [build_updated_answer(chair.subject_name, chair.id)]

      subject.update_answers(student, survey, answer_attributes)
      created_answer = Answer.last

      expect(created_answer.chair).to eq chair
      expect(created_answer.student).to eq student
      expect(created_answer.survey).to eq survey
    end

    def build_updated_answer(subject_name, selection)
      { name: subject_name, selectedChair: selection }
    end
  end
end
