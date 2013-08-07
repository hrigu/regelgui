class RegelnController < ApplicationController

  respond_to :json, :except => [:index]

  def index
    respond_to do |format|
      format.html #intex.html.erb
      format.json {
        @regeln = Regel.all
        render json: @regeln }
    end
  end

end


