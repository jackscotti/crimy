class CrimeFinder
  attr_reader :lat, :lng

  def initialize(lat:, lng:)
    @lat = lat
    @lng = lng
  end

  def crimes_at_location
    '''
    crimes at location
    https://data.police.uk/api/crimes-at-location?lat=#{lat}&lng=#{lng}
    '''
    url = "https://data.police.uk/api/crimes-at-location?lat=#{lat}&lng=#{lng}"
    HTTParty.get(url)
  end

  def crimes_within_1_mile_radious
    '''
    street level crimes (1 mile radious)
    "https://data.police.uk/api/crimes-street/all-crime?lat=#{lat}&lng=#{lng}"
    '''
    url = "https://data.police.uk/api/crimes-street/all-crime?lat=#{lat}&lng=#{lng}"
    response = HTTParty.get(url)

    groups = response.group_by {|x| "#{x['category']}"}
    groups.map {|k,v| {"type" => k, "total" => v.count} }.sort_by {|x| x["total"]}.reverse
  end
end
