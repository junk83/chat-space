class GroupsController < ApplicationController
  def index
    @groups = Group.includes(:users).where(group_users: {user_id: current_user.id})
  end
  
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to root_path, notice: 'グループが作成されました。'
    else
      render "new"
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, { user_ids: [] })
  end
end
