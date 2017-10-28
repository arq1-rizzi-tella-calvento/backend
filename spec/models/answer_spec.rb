require 'rails_helper'

describe Answer do
  context 'validations' do
    it { expect(subject).to validate_presence_of :student }
  end
end
