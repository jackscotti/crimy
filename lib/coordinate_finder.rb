class CoordinateFinder
  attr_reader :url, :postcode
  def initialize(url: nil, postcode: nil)
    @url = url
    @postcode = postcode
  end

  def coordinates
    # TODO: Extract to coordinate extractor object
    if url
      page = Nokogiri::HTML(get_content_at_url(url))
      if url.include?("zoopla")

        lat = page.xpath("//*[@itemprop='latitude']").xpath('@content').text
        lng = page.xpath("//*[@itemprop='longitude']").xpath('@content').text

        {lat: lat,lng: lng}
      elsif url.include?("rightmove")
        # pulling the coordinates out of the google map widget
        address = page.xpath("//img[@alt=\'Get map and local information'\]").first.xpath('@src').text
        address = address.split('?')[1].split('&')
        lat = address[0].split("=")[1]
        lng = address[1].split("=")[1]

        {lat: lat,lng: lng}
      else
        "Unknown site"
      end
    elsif postcode

      url = "https://mapit.mysociety.org/postcode/#{CGI.escape(postcode)}"

      response = get_content_at_url(url)

      raise "Not a valid or complete postcode inserted" if response.code == 400
      lat = response["wgs84_lat"]
      lng = response["wgs84_lon"]

      {lat: lat,lng: lng}
    end
  end

private

  def get_content_at_url(url)
    HTTParty.get(url)
  end
end
