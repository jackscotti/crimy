require 'httparty'
require 'nokogiri'
require 'pry'
require 'sinatra'
require "addressable/uri"

class CoordinateFinder
  attr_reader :url, :postcode
  def initialize(url: nil, postcode: nil)
    @url = url
    @postcode = postcode
  end

  def coordinates
    begin
      if url
        page = Nokogiri::HTML(HTTParty.get(url))
        if url.include?("zoopla")

          # these used to work then stopped
          # lat = page.xpath("//meta[@property=\'og:latitude'\]").xpath('@content').text
          # long = page.xpath("//meta[@property=\'og:longitude'\]").xpath('@content').text

          lat = page.xpath("//*[@itemprop='latitude']").xpath('@content').text
          long = page.xpath("//*[@itemprop='longitude']").xpath('@content').text

          {lat: lat,long: long}
        elsif url.include?("rightmove")
          # pulling the coordinates out of the google map widget
          address = page.xpath("//img[@alt=\'Get map and local information'\]").first.xpath('@src').text
          address = address.split('?')[1].split('&')
          lat = address[0].split("=")[1]
          long = address[1].split("=")[1]

          {lat: lat,long: long}
        else
          "Unknown site"
        end
      elsif postcode
        url = "https://mapit.mysociety.org/postcode/#{CGI.escape(postcode)}"
        response = HTTParty.get(url)

        lat = response["wgs84_lat"]
        long = response["wgs84_lon"]

        {lat: lat,long: long}
      end
    rescue
      raise "something went wrong"
    end
  end

end

get '/' do
  if params.any?
    uri = Addressable::URI.new
    symbolized_params = Hash[params.map{ |k, v| [k.to_sym, v] }]
    uri.query_values = CoordinateFinder.new(symbolized_params).coordinates
    redirect to '/crimes?' + uri.query
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
