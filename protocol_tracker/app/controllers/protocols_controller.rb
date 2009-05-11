class ProtocolsController < ApplicationController

  def show
    @protocol = Protocol.find_in_eirb(params[:id])
  end
end
