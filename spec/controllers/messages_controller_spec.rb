require 'rails_helper'

describe MessagesController do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:groups) { create_list(:group, 3, user_ids: user.id) }
  let(:message) { build(:message) }
  let(:messages) { create_list(:message, 3, user_id: user.id, group_id: group.id) }


  describe 'GET #index' do
    context "by anonymous user" do
      it "redirects to the new user session path" do
        get :index, params: { group_id: group.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "by login user" do

      before do
        sign_in user
      end

      after do
        sign_out user
      end

      it "assigns the requested contact to @groups" do
        get :index, params: { group_id: group.id}
        expect(assigns(:groups)).to match(groups)
      end

      it "assigns the requested contact to @messages" do
        get :index, params: { group_id: group.id}
        expect(assigns(:messages)).to match(messages)
      end

      it "renders the :index template" do
        get :index, params: { group_id: group.id }
        expect(response).to render_template :index
      end
    end
  end

  describe 'POST #create' do

    context "by anonymous user" do
      it "redirects to the new user session path" do
        post :create, params: { message: attributes_for(:message), group_id: group.id, user_id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "by login user" do
      before do
        sign_in user
      end

      after do
        sign_out user
      end

      it "assigns the requested contact to @group" do
        post :create, params: { message: attributes_for(:message), group_id: group.id, user_id: user.id }
        expect(assigns(:group)).to eq group
      end

      context "valid with a body" do
        it "saves the new message in the database" do
          expect{
            post :create, params: { message: attributes_for(:message), group_id: group.id, user_id: user.id }
          }.to change(Message, :count).by(1)
        end

        it "redirects to the group messages path" do
          post :create, params: { message: attributes_for(:message), group_id: group.id, user_id: user.id }
          expect(response).to redirect_to group_messages_path
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
          expect(response).to redirect_to group_messages_path
        end
      end
    end
  end
end
