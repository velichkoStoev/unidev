class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @sent_messages = Message.where(sender_id: current_user.id)
    @received_messages = Message.where(receiver_id: current_user.id)
  end

  def new
    @message = Message.new
    @users = User.where.not(id: current_user.id)
    respond_to { |format| format.js }
  end

  def create
    message_data = message_params.merge!(sender: current_user)
    @message = Message.new(message_data)
    @users = User.where.not(id: current_user.id)
    if @message.save
      flash[:notice] = 'Message was successfully sent!'
      flash.keep(:notice)
      render js: "window.location = '#{user_messages_path}'"
    else
      respond_to do |format|
        format.js { render 'new' }
      end
    end
  end

  def show
    @message = Message.find_by_id(params[:id])
    @message.update!(is_read: true) if @message.receiver_id == current_user.id
    respond_to { |format| format.js }
  end

  def new_request
    Message.create!(new_request_message_data)
    flash[:notice] = 'Your request was successfully sent!'
    redirect_to action: :index
  end

  def approve_request
    respond_to_request(:approve)
    ProjectParticipation.create!(project_id: params[:project_id], user_id: params[:receiver_id])
    flash[:notice] = 'Your approval was successfully sent!'
    redirect_to action: :index
  end

  def decline_request
    respond_to_request(:decline)
    flash[:notice] = 'Your decline was successfully sent!'
    redirect_to action: :index
  end

  private

  def new_request_message_data
    project = Project.find_by_id(params[:project_id])

    {
      sender_id: current_user.id,
      receiver_id: params[:receiver_id],
      is_request: true,
      project_id: project.id,
      title: 'New participation request',
      body: "Hi, I'm #{current_user.full_name}, and I want to join your project #{project.name}. Is it okay with you?"
    }
  end

  def respond_to_request(request_type)
    Message.create!(request_response_content(request_type))
    Message.find_by_id(params[:request_message_id]).update!(is_request_handled: true)
  end

  def request_response_content(response_type)
    user_content = { sender_id: current_user.id, receiver_id: params[:receiver_id] }

    text_content = {
      approve: { title: 'Approved request!', body: 'Congrats, your request has been approved!' },
      decline: { title: 'Approved request!', body: 'Congrats, your request has been approved!' }
    }

    user_content.merge(text_content[response_type])
  end

  def message_params
    params.require(:message).permit(:receiver_id, :title, :body)
  end
end
