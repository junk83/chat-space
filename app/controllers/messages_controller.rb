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
    if @message.valid?
      @message.save
      respond_to do |format|
        format.html { redirect_to group_messages_path(@group) }
        format.json { render json: {
            status: 200,
            body: @message.body,
            name: @message.user.name,
            created_at: @message.created_at.strftime("%Y/%m/%d %H:%M:%S")
          }
         }
      end
    else
      respond_to do |format|
        format.html {
          redirect_to group_messages_path(@group), alert: @message.errors.full_messages[0]
        }
        format.json { render json: {
            status: 400,
            alert: @message.errors.full_messages[0]
          }
        }
      end
    end
  end

  private
  def message_params
    params.require(:message).permit(:body).merge(user_id: current_user.id, group_id: params[:group_id])
  end
end
