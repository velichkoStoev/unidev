class MessagesController < ApplicationController
  before_action :authenticate_user!, except: :home

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
    Message.create!(message_data)
    flash[:notice] = 'Message was successfully sent!'
    redirect_to action: :index
  end

  def show
    @message = Message.find_by_id(params[:id])
    @message.update!(is_read: true) if @message.receiver_id == current_user.id
    respond_to { |format| format.js }
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :title, :body)
  end
end
