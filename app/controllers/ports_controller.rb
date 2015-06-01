class PortsController < ApplicationController
  def new
    @port = Port.new
  end
  def create
    @port = Port.new(port_params)
    @port.update(:user_id => current_user.id)
    if @port.save
      redirect_to '/ports'
    else
      redirect_to '/'
    end
  end

  def destroy
    @port = Port.find(params[:port_id])
    if @port[:user_id] == current_user.id
      @port.destroy
    end
    redirect_to '/ports'
  end

  private
  def port_params
    params.require(:port).permit(:dest_port, :user_id)
  end
end
