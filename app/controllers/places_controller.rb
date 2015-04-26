class PlacesController < ApplicationController
	def new
		@place = Place.new
	end

	def create
		@place = Place.new(place_params)
		if @place.save
			flash[:success] = "You have succesfully saved #{@place.name}"
			redirect_to new_place_path
		else
			render 'new'
		end
	end

	def show
		@place = Place.find(params[:id])
	end

	def index
		@place = Place.offset(rand(Place.count)).first
		respond_to do |format|
			format.html do
				render 'index'
			end
			format.js do
				render 'index'
			end
		end
	end

	private

	def place_params
		params.require(:place).permit(:picture, :location_code, :name)
	end

end
