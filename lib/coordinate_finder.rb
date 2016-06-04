class CoordinateFinder
  attr_reader :url, :postcode
  def initialize(url: nil, postcode: nil)
    @url = url
    @postcode = postcode
  end

  def coordinates
      if url
        page = Nokogiri::HTML(get_content(url))
        if url.include?("zoopla")

          lat = page.xpath("//*[@itemprop='latitude']").xpath('@content').text
          lng = page.xpath("//*[@itemprop='longitude']").xpath('@content').text
          raise "whoops, something went wrong!" if lat.empty? or lng.empty?
          {lat: lat,lng: lng}
        elsif url.include?("rightmove")
          begin
            # pulling the coordinates out of the google map widget
            address = page.xpath("//img[@alt=\'Get map and local information'\]").first.xpath('@src').text
            address = address.split('?')[1].split('&')
            lat = address[0].split("=")[1]
            lng = address[1].split("=")[1]

            {lat: lat,lng: lng}
          rescue
            raise "whoops, something went wrong!"
          end
        else
          "Unknown site"
        end
      elsif postcode
        response = get_content

        raise response["error"] if response["code"] == 400

        lat = response["wgs84_lat"]
        lng = response["wgs84_lon"]

        {lat: lat,lng: lng}
      end
  end

private
  def get_content(url = nil)
    url = "https://mapit.mysociety.org/postcode/#{CGI.escape(postcode)}" if postcode
    # might need to transform this into a hash
    HTTParty.get(url)
  end
end
