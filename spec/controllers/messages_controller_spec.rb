require 'rails_helper'

describe MessagesController do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:message) { build(:message) }

  before do
    login_user user
  end

  describe 'GET #index' do
    it "renders the :index template" do
      get :index, params: { group_id: group.id }
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context "valid with a body" do
      it "saves the new message in the database" do
        expect{
          post :create, params: { message: attributes_for(:message), group_id: group.id, user_id: user.id }
        }.to change(Message, :count).by(1)
      end

      it "redirects to the group messages path" do
        post :create, params: { message: attributes_for(:message), group_id: group.id, user_id: user.id }
        expect(response).to redirect_to group_messages_path(assigns(:group))
      end
    end

    context "invalid without a body" do
      it "does not save the new message in the database" do
        expect{
            post :create, params: { message: attributes_for(:message, body: nil), group_id: group.id, user_id: user.id }
          }.not_to change(User, :count)
      end

      it "redirects to the group messages path" do
        post :create, params: { message: attributes_for(:message, body: nil), group_id: group.id, user_id: user.id }
        expect(response).to redirect_to group_messages_path(assigns(:group))
      end
    end
  end
end
