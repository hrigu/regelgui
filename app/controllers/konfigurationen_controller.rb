# -*- encoding : utf-8 -*-

class KonfigurationenController < ApplicationController

  respond_to :json

  #TODO regelgui: Nur die Felder raufschicken, die nötig sind. Also die grünorangerot felder weglassen
  def index
    all =  Konfiguration.all
    render json: all, methods: [:gruenorangerot_position_100, :typ, :mitarbeiter_ids]
  end

  def update
    p = Konfiguration.find params[:id]
    p.update_attributes params[:konfiguration]
    respond_with p
  end

  def create
    k = Konfiguration.new(params[:konfiguration])
    k.save
    respond_with k
  end

  def destroy
    k = Konfiguration.find(params[:id])
    k.destroy()
    respond_with k
  end

end


