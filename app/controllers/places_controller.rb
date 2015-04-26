class PlacesController < ApplicationController
	def new
		session.delete(:places)
		session.delete(:no)
		session.delete(:showed)
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
		@place_array = session[:showed]
		puts "SESSION BROGO: #{@place_array.inspect}"
		if @place_array
			while(@place_array.include?(@place.id)) do
				puts "IN THE LOOP YO"
				@place = Place.offset(rand(Place.count)).first
				if @place_array.count >= Place.count
					@out = true
					break
				end
			end

		end
		respond_to do |format|
			format.html do
				if session.delete(:places)
					puts "DELETED YO"
				end
				session.delete(:no)
				session.delete(:showed)
				render 'index'
			end
			format.js do
				if @out
					redirect_to suggestions_path
				else
					render 'index'
				end
			end
		end
	end

	def suggestions
		session.delete(:no)
		session.delete(:showed)
		@places = session[:places]
		@details = Detail.find(session[:detail]) 
		session.delete(:places)

	end

	def place_logic
		@decision = params[:decision]
		@place = Place.find(params[:place_id])
		if @decision == "yes"
			if session[:places]
				session[:places].push(@place.id)
			else
				session[:places] = [@place.id]
			end
			puts "heres session PLACES: " + session[:places].inspect.to_s
		elsif @decision == "no"
			if session[:no]
				session[:no].push(@place.id)
			else
				session[:no] = [@place.id]
			end
			puts "heres session NO: " + session[:no].inspect.to_s
		end
		if session[:showed]
			session[:showed].push(@place.id)
		else
			session[:showed] = [@place.id]
		end

		if session[:places].count >= 3
			redirect_to suggestions_path
		else
			redirect_to places_path
		end
	end

	private

	def place_params
		params.require(:place).permit(:picture, :location_code, :name)
	end

end
