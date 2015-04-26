# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'net/http'
require 'pry'
require 'json'
require 'open-uri'
require 'csv'
require 'flickraw'

Place.delete_all

city_codes = ['AAA', 'NYC', 'BOS', 'CHI', 'AAP', 'IST', 'LOS', 'LAS', 'NAS', 'EBA', 'GBE', 'MEE', 'ANK', 'AKA']

FlickRaw.api_key="90ed083aedefd5a56136bcbc63462a72"
FlickRaw.shared_secret="36aa3629e817ca34"

# csv_url = 'https://raw.githubusercontent.com/opentraveldata/geobases/public/GeoBases/DataSources/Por/Ori/ori_por_public.csv'
# url_data = open(csv_url).read()
# data = url_data.gsub(/\^+/, ',')
# csv = data.split(/\n/)
# city_codes = []
# csv.to_a.map! { |line| line.split(',') }
# csv.each { |data| city_codes << data[0] }
# city_codes.shift
# city_codes.uniq!

def get_location_data(location_code)
  uri = URI("http://api.sandbox.amadeus.com/v1.2/location/#{location_code}/?apikey=s6p1jBl7ANYD92AGltGDCBy5yQq7Mfct")
  str_data = Net::HTTP.get(uri)
  data = JSON.parse(str_data)
end

def get_image(name)
  args = {}
  new_b = flickr.places.find :query => name
  args[:min_taken_date] = '2014-01-01 00:00:00'
  args[:max_taken_date] = '2015-01-01 00:00:00'
  args[:accuracy] = 1 # the default is street only granularity [16], which most images aren't...
  discovered_pictures = flickr.photos.search args
  image_urls = []
  discovered_pictures.each { |p| image_urls << FlickRaw.url(p) }
  image_urls[0]
end

city_codes.each do |city_code|
  location_data = get_location_data(city_code)
  next if location_data['airports'].nil? # eliminates the city if it does not have an airport
  name = location_data['airports'][0]['city_name']
  binding.pry
  location_code = location_data['airports'][0]['city_code']
  image_url = get_image(name)
  @place = Place.new(picture: image_url, name: name, location_code: location_code)
  @place.remote_picture_url = "#{image_url}"
  @place.save
end


