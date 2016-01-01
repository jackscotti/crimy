require 'httparty'
require 'nokogiri'
require 'pry'
require 'sinatra'
require 'addressable/uri'

require_relative 'coordinate_finder'
require_relative 'query_builder'

get '/' do
  if params.any?
    redirect to '/crimes?' + QueryBuilder.new(params).query
  else
    erb :index
  end
end

get '/crimes' do
  @lat = params['lat']
  @long = params['long']

  unless @lat && @long
    "you must provide <strong>lat</strong> and <strong>long</strong> in the body of your request"
  else
    erb :crimes, locals: {
      lat: @lat,
      long: @long,
      crimes_at_location: crimes_at_location,
      crimes_1_mile_radious: crimes_1_mile_radious,
    }
  end
end

def crimes_at_location
  '''
  crimes at location
  https://data.police.uk/api/crimes-at-location?lat=#{lat}&lng=#{long}
  '''
  url = "https://data.police.uk/api/crimes-at-location?lat=#{@lat}&lng=#{@long}"
  HTTParty.get(url)
end
def crimes_1_mile_radious
  '''
  street level crimes (1 mile radious)
  "https://data.police.uk/api/crimes-street/all-crime?lat=#{lat}&lng=#{long}"
  '''
  url = "https://data.police.uk/api/crimes-street/all-crime?lat=#{@lat}&lng=#{@long}"
  response = HTTParty.get(url)

  groups = response.group_by {|x| "#{x['category']}"}
  groups.map {|k,v| {"type" => k, "total" => v.count} }.sort_by {|x| x["total"]}.reverse
end
