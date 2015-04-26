class Place < ActiveRecord::Base
	mount_uploader :picture, PictureUploader

	def get_flight_details(detail)
		@detail = detail
		@start_date = @detail.start_date
			@start_year = @start_date.year
			@start_month = @start_date.strftime("%m")
			@start_day = @start_date.day
		@end_date = @detail.end_date
			@end_year = @end_date.year
			@end_month = @end_date.strftime("%m")
			@end_day = @end_date.day
		@formatted_date = "#{@start_year}-#{@start_month}-#{@start_day}--#{@end_year}-#{@end_month}-#{@end_day}"
		puts "THE DATE IS #{@formatted_date}"
		flight_uri = URI("http://api.sandbox.amadeus.com/v1.2/flights/extensive-search?origin=BOS&destination=#{self.location_code}&departure_date=#{@formatted_date}&duration=7--9&max_price=#{@detail.high_price}&apikey=s6p1jBl7ANYD92AGltGDCBy5yQq7Mfct")
		str_flight_data = Net::HTTP.get(flight_uri)
		flight_data = JSON.parse(str_flight_data)
	end

end
