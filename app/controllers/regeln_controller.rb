class RegelnController < ApplicationController

  respond_to :json, :except => [:index]

  def index
    respond_to do |format|
      format.html #intex.html.erb
      format.json {
        @regeln = Regel.rank(:sort_order).all
        render json: @regeln
      }
    end
  end

  def update
    regel = Regel.find(params[:id])
    position = params[:sort_order_position]
    regel.update_attribute(:sort_order_position, position)
    respond_with regel
  end

end



