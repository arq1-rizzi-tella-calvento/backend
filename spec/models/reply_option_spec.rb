require 'rails_helper'

describe ReplyOption do
  context 'validations' do
    it { expect(subject).to validate_inclusion_of(:value).in_array ReplyOption::REPLY_OPTIONS }
  end
end
