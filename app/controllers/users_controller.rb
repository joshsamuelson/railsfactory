class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if User.find_by(username: user_params[:username])
      redirect_to '/error'
    else 
    @user = User.new(user_params)
    @user.save
    
    port_80 = Port.new(:user_id => @user.id, :dest_port => 80)
    port_80.save

    port_8080 = Port.new(:user_id => @user.id, :dest_port => 8080)
    port_8080.save
    
    container = Docker::Container.create(
      "Cmd" => ["/sbin/my_init"],
      "Image" => "phusion/baseimage",
      "ExposedPorts" => {
        "80/tcp" => [{ "HostPort" => (port_80.id + 10000).to_s}],
        "8080/tcp" => [{"HostPort" => (port_8080.id + 10000).to_s}]
      },
      "HostConfig" => {
        "PortBindings" => [
          "80/tcp" => [
            {
              "HostPort" => (port_80.id + 10000).to_s
            }
          ],
          "8080/tcp" => [
            {
              "HostPort" => (port_8080.id + 10000).to_s
            }
          ]
        ]
      }
      
    )
    container.start
    @user.update(:container_id => container.json['Id'])
    if @user.save
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
