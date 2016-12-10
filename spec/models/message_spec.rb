require 'rails_helper'

describe Message do
  describe '#create' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let(:message) { build(:message) }

    it "is valid with a body, user_id, group_id" do
      message.user_id = user.id
      message.group_id = group.id
      expect(message).to be_valid
    end

    it "is invalid without a body" do
      message.body = nil
      message.user_id = user.id
      message.group_id = group.id
      message.valid?
      expect(message.errors[:body]).to include("を入力してください。")
    end

    it "is invalid without a user_id" do
      message.user_id = nil
      message.group_id = group.id
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください。")
    end

    it "is invalid without a group_id" do
      message.user_id = user.id
      message.group_id = nil
      message.valid?
      expect(message.errors[:group_id]).to include("を入力してください。")
    end
  end
end
