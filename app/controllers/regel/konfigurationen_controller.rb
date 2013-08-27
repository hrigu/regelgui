# -*- encoding : utf-8 -*-

class Regel::KonfigurationenController < ApplicationController

  respond_to :json

  #TODO regelgui: Nur die Felder raufschicken, die nötig sind. Also die grünorangerot felder weglassen
  def index
    all = Regel::Konfiguration.all
    render json: all, methods: [:gruenorangerot_position_100, :typ, :mitarbeiter_ids]
  end

  def update
    p = Regel::Konfiguration.find params[:id]
    p.update_attributes params[:konfiguration]
    respond_with p
  end

  def create
    k = Regel::Konfiguration.new(params[:konfiguration])
    k.save
    respond_with k
  end

  def destroy
    k = Regel::Konfiguration.find(params[:id])
    k.destroy()
    respond_with k
  end

end


