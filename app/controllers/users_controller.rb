class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if User.find_by(username: user_params[:username])
      redirect_to '/error'
    else 
    container = Docker::Container.create(
      "Cmd" => ["/sbin/my_init"],
      "Image" => "phusion/baseimage",
    )
    @user = User.new(user_params)
    if @user.save
      container.start
      User.update(@user.id, :container_id => container.json['Id'])
      session[:user_id] = @user.id
      redirect_to '/'
    else
      container.delete
      redirect_to '/signup'
    end
    end
  end

  private
  def user_params
    params.require(:user).permit(:username,:password,:container_id)
  end
end
