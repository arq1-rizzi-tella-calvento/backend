require 'rails_helper'

describe Chair do
  context 'validations' do
    it { expect(subject).to validate_presence_of(:subject_in_quarter) }
  end

  context '.with_over_demand' do
    let!(:chair_with_over_demand) { create :chair, :with_over_demand }
    let!(:another_chair_with_over_demand) { create :chair, :with_over_demand }
    let!(:chair) { create :chair }

    it 'returns chairs which number of students enrolled is greated than the quota' do
      expected_chairs = Chair.where(id: [chair_with_over_demand, another_chair_with_over_demand])

      expect(Chair.with_over_demand).to match_array expected_chairs
    end
  end

  context '#number_of_students' do
    let(:subject) { build :chair }

    before do
      4.times do
        student = build :student
        subject.answers << build(:answer, student: student, chair: subject)
      end
    end

    it 'returns the number of students that want to attend the class' do
      expect(subject.number_of_students).to eq 4
    end
  end
end
