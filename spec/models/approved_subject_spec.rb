require 'rails_helper'

describe ApprovedSubject do
  context 'validations' do
    it { expect(subject).to validate_presence_of :subject }
    it { expect(subject).to validate_presence_of :student }
  end
end
