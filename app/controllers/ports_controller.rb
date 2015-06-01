class PortsController < ApplicationController

  def new
    @port = Port.new
  end

  private
  def port_params
    params.require(:port).permit(:dest_port, :user_id)
  end
end
