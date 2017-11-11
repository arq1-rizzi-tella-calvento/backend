require 'rails_helper'

describe Student do
  context 'validations' do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :identity_document }
    it { expect(subject).to validate_presence_of :email }
  end
end
