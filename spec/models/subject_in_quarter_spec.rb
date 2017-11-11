require 'rails_helper'

describe SubjectInQuarter do
  context 'validations' do
    it { expect(subject).to validate_presence_of(:subject) }
    it { expect(subject).to validate_presence_of(:survey) }
  end
end
