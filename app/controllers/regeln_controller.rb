class RegelnController < ApplicationController
  def index
    @regeln = Regel.all
  end
end