require 'httparty'
require 'nokogiri'
require 'pry'

class CoordinateFinder
  attr_reader :url
  def initialize(url)
    @url = url
  end

  def coordinates
    page = Nokogiri::HTML(HTTParty.get(url))

    if url.include?("zoopla")
      lat = page.xpath("//meta[@property=\'og:latitude'\]").xpath('@content').text
      long = page.xpath("//meta[@property=\'og:longitude'\]").xpath('@content').text
      return lat,long
    elsif url.include?("rightmove")
      # pulling the coordinates out of the google map widget
      address = page.xpath("//img[@alt=\'Get map and local information'\]").first.xpath('@src').text
      address = address.split('?')[1].split('&')
      lat = address[0].split("=")[1]
      long = address[1].split("=")[1]
      return lat,long
    else
      "Unknown site"
    end
  end
end
