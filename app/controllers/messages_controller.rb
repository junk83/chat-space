class MessagesController < GroupsController
  layout "chat_space"

  def index
    @groups = group_list
    @group = Group.find(params[:group_id])
    @messages = Message.includes(:user).where(group_id: params[:group_id])
    @message = Message.new
  end

  def create
    @group = Group.find(params[:group_id])
    @message = Message.new(message_params)
    if @message.save
      redirect_to group_messages_path(@group)
    else
      redirect_to group_messages_path(@group), alert: @message.errors.full_messages[0]
    end
  end

  private
  def message_params
    params.require(:message).permit(:body).merge(user_id: current_user.id, group_id: params[:group_id])
  end
end
