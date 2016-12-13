class GroupsController < ApplicationController

  def index
    @groups = group_list
    render layout: "chat_space"
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to group_messages_path(@group), notice: 'グループが作成されました。'
    else
      render :new
    end
  end

  def edit
    @group = Group.includes(:users).find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to group_messages_path(@group), notice: 'チャットグループが更新されました。'
    else
      render :edit
    end
  end

  private
  def group_list
    Group.includes(:users).where(group_users: {user_id: current_user.id})
  end

  def group_params
    params.require(:group).permit(:name, { user_ids: [] })
  end
end
