class CrimeFinder
  attr_reader :lat, :long

  def initialize(lat:, long:)
    @lat = lat
    @long = long
  end

  def crimes_at_location
    '''
    crimes at location
    https://data.police.uk/api/crimes-at-location?lat=#{lat}&lng=#{long}
    '''
    url = "https://data.police.uk/api/crimes-at-location?lat=#{@lat}&lng=#{@long}"
    HTTParty.get(url)
  end

  def crimes_within_1_mile_radious
    '''
    street level crimes (1 mile radious)
    "https://data.police.uk/api/crimes-street/all-crime?lat=#{lat}&lng=#{long}"
    '''
    url = "https://data.police.uk/api/crimes-street/all-crime?lat=#{@lat}&lng=#{@long}"
    response = HTTParty.get(url)

    groups = response.group_by {|x| "#{x['category']}"}
    groups.map {|k,v| {"type" => k, "total" => v.count} }.sort_by {|x| x["total"]}.reverse
  end
end
