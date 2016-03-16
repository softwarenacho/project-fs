class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @team = TeamPlayer.where(team_id: params[:id])
    unless @team.empty?
      gk = @team.find {|p| p.position == "GK"}
        if gk == nil
          @team = @team.sort {|a,b| a.position <=> b.position}
        else
          @team = @team.sort {|a,b| a.position <=> b.position}
          @team = @team.unshift(gk).uniq
        end
      @players = []
      @team.each do |p|
        id = p.player_id
        @players << Player.find_by(fifa_id: id)
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
    
    # user = User.from_omniauth(env["omniauth.auth"])
    # session[:user_id] = user.id
    # redirect_to root_url
    
    
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

  def admin_user
      redirect_to(root_url) unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
