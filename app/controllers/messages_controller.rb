class MessagesController < GroupsController
  layout "chat_space"

  def index
    @groups = group_list
    @group = Group.find(params[:group_id])
  end
end
