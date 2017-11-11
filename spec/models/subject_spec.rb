require 'rails_helper'

describe Subject do
  context 'validations' do
    it { expect(subject).to validate_presence_of :name }
  end
end
