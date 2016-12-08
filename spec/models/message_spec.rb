require 'rails_helper'

describe Message do
  describe '#create' do
    let(:message) { build(:message) }

    it "is valid with a body" do
      expect(message).to be_valid
    end

    it "is invalid without a body" do
      message.body = nil
      message.valid?
      expect(message.errors[:body]).to include("を入力してください。")
    end
  end
end
