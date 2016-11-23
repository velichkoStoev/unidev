require 'rails_helper'

describe MessagesController do
  let!(:current_user) { FactoryGirl.create(:user) }

  before { sign_in current_user }

  describe 'POST create' do
    let!(:receiver) { FactoryGirl.create(:user) }

    let(:flash_notice_message) { 'Message was successfully sent!' }

    let(:params) do
      {
        message: {
          title: 'Title',
          body: 'Body',
          receiver_id: receiver.id
        },
        user_id: current_user.id
      }
    end

    context 'when the params are valid' do
      before { xhr :post, :create, params, format: :js }

      it { expect(response).to have_http_status(:ok) }
      it { expect(flash[:notice]).to eq(flash_notice_message) }

      it 'creates the message with a valid data' do
        message = Message.first

        expect(message.title).to eq('Title')
        expect(message.body).to eq('Body')
        expect(message.receiver).to eq(receiver)
        expect(message.sender).to eq(current_user)
      end
    end

    context 'when the params are invalid' do
      before do
        params[:message].delete(:title)
        xhr :post, :create, params, format: :js
      end

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'GET show' do
    let!(:message) { FactoryGirl.create(:message, receiver: current_user) }

    let(:params) { { user_id: current_user.id, id: message.id } }

    before { xhr :get, :show, params, format: :js }

    it { expect(response).to render_template(:show) }
    it { expect(response).to have_http_status(:ok) }
    it { expect(Message.first.is_read).to be_truthy }
  end

  describe 'POST new_request' do
    let!(:project_creator) { FactoryGirl.create(:user) }
    let!(:project) { FactoryGirl.create(:project, creator: project_creator) }

    let(:flash_notice_message) { 'Your request was successfully sent!' }
    let(:new_request_title) { 'New participation request' }

    let(:new_request_body) do
      "Hi, I'm #{current_user.full_name}, and I want to join your project #{project.name}. Is it okay with you?"
    end

    let(:params) do
      {
        receiver_id: project_creator.id,
        project_id: project.id,
        user_id: current_user.id
      }
    end

    before { post :new_request, params }

    it 'creates the request message' do
      request = Message.first

      expect(request.title).to eq(new_request_title)
      expect(request.body).to eq(new_request_body)
      expect(request.is_request).to be_truthy
      expect(request.project_id).to eq(project.id)
      expect(request.sender_id).to eq(current_user.id)
      expect(request.receiver_id).to eq(project_creator.id)
    end

    it { expect(flash[:notice]).to eq(flash_notice_message) }
    it { expect(response).to redirect_to(user_messages_path) }
  end

  describe 'POST approve_request' do
    let!(:request) { FactoryGirl.create(:message, is_request: true) }
    let!(:receiver) { FactoryGirl.create(:user) }
    let!(:project) { FactoryGirl.create(:project, creator: current_user) }

    let(:flash_notice_message) { 'Your approval was successfully sent!' }
    let(:approved_request_title) { 'Approved request!' }
    let(:approved_request_body) { 'Congrats, your request has been approved!' }

    let(:params) do
      {
        receiver_id: receiver.id,
        user_id: current_user.id,
        project_id: project.id,
        request_message_id: request.id
      }
    end

    before { post :approve_request, params }

    it 'creates the creates the approval message' do
      approval_message = Message.last

      expect(approval_message.title).to eq(approved_request_title)
      expect(approval_message.body).to eq(approved_request_body)
      expect(approval_message.sender_id).to eq(current_user.id)
      expect(approval_message.receiver_id).to eq(receiver.id)
    end

    it 'creates project participation' do
      project_participation = ProjectParticipation.first

      expect(project_participation.project_id).to eq(project.id)
      expect(project_participation.user_id).to eq(receiver.id)
    end

    it { expect(request.reload.is_request_handled).to be_truthy }
    it { expect(flash[:notice]).to eq(flash_notice_message) }
    it { expect(response).to redirect_to(user_messages_path) }
  end

  describe 'POST decline_request' do
    let!(:request) { FactoryGirl.create(:message, is_request: true) }
    let!(:receiver) { FactoryGirl.create(:user) }
    let!(:project) { FactoryGirl.create(:project, creator: current_user) }

    let(:flash_notice_message) { 'Your decline was successfully sent!' }
    let(:declined_request_title) { 'Declined request!' }
    let(:declined_request_body) { "Unfortunately, #{current_user.full_name} doesn't want you in his project." }

    let(:params) do
      {
        receiver_id: receiver.id,
        user_id: current_user.id,
        project_id: project.id,
        request_message_id: request.id
      }
    end

    before { post :decline_request, params }

    it 'creates the declined request message' do
      declined_message = Message.last

      expect(declined_message.title).to eq(declined_request_title)
      expect(declined_message.body).to eq(declined_request_body)
      expect(declined_message.sender_id).to eq(current_user.id)
      expect(declined_message.receiver_id).to eq(receiver.id)
    end

    it { expect(request.reload.is_request_handled).to be_truthy }
    it { expect(flash[:notice]).to eq(flash_notice_message) }
    it { expect(response).to redirect_to(user_messages_path) }
  end
end
