class DetailsController < ApplicationController
  
  def create
  	@detail = Detail.new(detail_params)
  	if @detail.save
  		redirect_to places_path
  	else
  		render 'index'
  	end
  end


  private

  def detail_params
  	params.require(:detail).permit(:start_date, :end_date, :high_price)
  end
end
