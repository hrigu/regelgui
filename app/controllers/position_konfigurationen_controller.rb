# -*- encoding : utf-8 -*-

class PositionKonfigurationenController < ApplicationController

  respond_to :json

  #TODO regelgui: Nur die Felder raufschicken, die nötig sind. Also die grünorangerot felder weglassen
  def index
    render json: PositionKonfiguration.all, methods: [:gruenorangerot_position_100, :mitarbeiter_ids]
  end

  def update
    p = PositionKonfiguration.find params[:id]
    p.update_attributes params[:position_konfiguration]
    respond_with p
  end

end


