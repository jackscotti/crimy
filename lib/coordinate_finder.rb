class CoordinateFinder
  attr_reader :url, :postcode, :type
  def initialize(params = {})
    @url = params.fetch("url", nil)
    @postcode = params.fetch("postcode", nil)
    @type = set_type
  end

  def find
    page = request_page

    case type
    when :rightmove
      begin
        # pulls the coordinates out of the google map widget
        address = page.xpath("//img[@alt=\'Get map and local information'\]").first.xpath('@src').text
        address = address.split('?')[1].split('&')
        lat = address[0].split("=")[1]
        lng = address[1].split("=")[1]
      rescue
        raise "whoops, something went wrong!"
      end
    when :zoopla
      lat = page.xpath("//*[@itemprop='latitude']").xpath('@content').text
      lng = page.xpath("//*[@itemprop='longitude']").xpath('@content').text
      raise "whoops, something went wrong!" if lat.empty? or lng.empty?
    when :postcode
      raise page["error"] if page["code"] == 400

      lat = page["wgs84_lat"]
      lng = page["wgs84_lon"]
    end
    {lat: lat,lng: lng}
  end

private

  def request_page
    case type
    when :zoopla, :rightmove
      Nokogiri::HTML(get_content(url))
    when :postcode
      url = "https://mapit.mysociety.org/postcode/#{CGI.escape(postcode)}"
      get_content(url)
    end
  end

  def set_type
    if postcode
      :postcode
    elsif url.include?("zoopla")
      :zoopla
    elsif url.include?("rightmove")
      :rightmove
    end
  end

  def get_content(url)
    HTTParty.get(url)
  end
end
