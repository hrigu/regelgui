class HomeController < ApplicationController
  def index
    @users = User.all
  end
  def test
  end
end
