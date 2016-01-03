require 'coordinate_finder'

describe "#coordinates" do
  context "providing a postcode" do
    context "Mapit does not find the postcode" do
      it "raises an error" do
        stub_request(:get, "https://mapit.mysociety.org/postcode/XXXX").
         to_return(:status => 400, :body => "")

        finder = CoordinateFinder.new(postcode: "XXXX")
        expect { finder.coordinates }.to raise_error "Not a valid or complete postcode inserted"
      end
    end
    # context "Mapit finds the postcode" do
    #   it "returns lat and long" do
    #     stub_request(:get, "https://mapit.mysociety.org/postcode/XXXX").
    #      to_return(:status => 200, :body => '"wgs84_lat": 51.5, "wgs84_lon": -0.1')
    #
    #      finder = CoordinateFinder.new(postcode: "XXXX")
    #
    #      expect(finder.coordinates["lat"]).to eq("51.5")
    #      expect(finder.coordinates["lng"]).to eq("-0.1")
    #    end
    #  end
  end
end
