class HomeController < ApplicationController
  def parking
    @parkings = Parking.all.pluck(:id, :address)
  end

  def help
  end

  def price
  end


end
