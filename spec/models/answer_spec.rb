require 'rails_helper'

describe Answer do
  context 'validations' do
    it { expect(subject).to validate_presence_of :student }

    it do
      subject.reply_option = nil

      expect(subject).to validate_presence_of(:chair)
    end

    it do
      subject.chair = nil

      expect(subject).to validate_presence_of(:reply_option)
    end
  end
end
