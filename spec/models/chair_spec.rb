require 'rails_helper'

describe Chair do
  context 'validations' do
    it { expect(subject).to validate_presence_of(:subject) }
  end
end
