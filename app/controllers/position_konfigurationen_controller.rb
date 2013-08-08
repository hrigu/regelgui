class PositionKonfigurationenController < ApplicationController

  respond_to :json

  def index
    render json: PositionKonfiguration.all, methods: :gruenorangerot_position_100
  end

  def update
    p = PositionKonfiguration.find params[:id]
    p.update_attributes params[:position_konfiguration]
    respond_with p
  end

end


