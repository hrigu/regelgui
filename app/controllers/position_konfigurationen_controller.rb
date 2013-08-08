class PositionKonfigurationenController < ApplicationController

  respond_to :json

  def index
    render json: PositionKonfiguration.all
  end

end


