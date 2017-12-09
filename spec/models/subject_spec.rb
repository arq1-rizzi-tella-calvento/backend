require 'rails_helper'

describe Subject do
  context 'validations' do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_uniqueness_of(:name).case_insensitive }
  end
end
