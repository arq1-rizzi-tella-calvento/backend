require 'rails_helper'

describe Student do
  context 'validations' do
    it { expect(subject).to validate_presence_of(:name).on :enroll }
    it { expect(subject).to validate_uniqueness_of(:identity_document).on :enroll }
    it { expect(subject).to validate_uniqueness_of :email }
    it { expect(subject).to validate_presence_of(:identity_document).on :enroll }
    it { expect(subject).to validate_presence_of :email }
  end
end
