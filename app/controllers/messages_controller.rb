class MessagesController < GroupsController
  layout "chat_space"

  def index
    @groups = group_list
    @group = Group.find(params[:group_id])
    @messages = Message.includes(:user).where(group_id: params[:group_id])
    @message = Message.new

    respond_to do |format|
      format.html { render :index }
      format.json {
        message_array = []
        @messages.each do |message|
          message_array << {
            body: message.body,
            name: message.user.name,
            image_url: message.image.url,
            created_at: message.created_at.strftime("%Y/%m/%d %H:%M:%S")
          }
        end
        render json: {
          messages: message_array
        }
      }
    end
  end

  def create
    @group = Group.find(params[:group_id])
    @message = Message.new(message_params)

    # 画像が投稿されたが、メッセージが空の場合
    @message.body = '画像を送信しました。' if message_params[:image] && @message.body.empty?

    if @message.valid?
      @message.save
      respond_to do |format|
        format.html { redirect_to group_messages_path(@group) }
        format.json { render json: {
            status: 200,
            body: @message.body,
            name: @message.user.name,
            image_url: @message.image.url,
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
    params.require(:message).permit(:body, :image).merge(user_id: current_user.id, group_id: params[:group_id])
  end
end
