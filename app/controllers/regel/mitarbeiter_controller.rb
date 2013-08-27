class Regel::MitarbeiterController < ApplicationController

  respond_to :json

  def index
    respond_with Mitarbeiter.all
  end
end



