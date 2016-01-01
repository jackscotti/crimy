require 'httparty'
require 'nokogiri'
require 'pry'
require 'sinatra'
require 'addressable/uri'

require_relative 'coordinate_finder'
require_relative 'query_builder'
require_relative 'crime_finder'

get '/' do
  if params.any?
    redirect to '/crimes?' + QueryBuilder.new(params).query
  else
    erb :index
  end
end

get '/crimes' do
  lat = params['lat']
  long = params['long']

  unless lat && long
    # FIXME: this shows up if a non existing postcode has been provided
    "you must provide <strong>lat</strong> and <strong>long</strong> in the body of your request"
  else
    finder = CrimeFinder.new(lat: lat, long: long)
    
    erb :crimes, locals: {
      lat: lat,
      long: long,
      crimes_at_location: finder.crimes_at_location,
      crimes_1_mile_radious: finder.crimes_within_1_mile_radious,
    }
  end
end
