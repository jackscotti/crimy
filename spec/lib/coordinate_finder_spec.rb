require 'coordinate_finder'
require 'spec_helper'

# Warning: These tests could pass if MapIt changed its API.
describe "#coordinates" do
  context "providing a postcode" do
    context "Mapit does not find the postcode" do
      it "raises an error" do
        response = {
          "code" => 400,
          "error" => "Postcode 'XXXX' is not valid.",
        }

        finder = CoordinateFinder.new(postcode: "XXXX")
        allow(finder).to receive(:get_content) { response }

        expect { finder.coordinates }.to raise_error "Not a valid or complete postcode inserted"
      end
    end
    context "Mapit finds the postcode" do
      it "returns lat and long" do
        response = {
          "wgs84_lat" => 51.51695998250193,
          "wgs84_lon" => -0.12060134310237684,
          "postcode" => "WC2B 6NH",
        }

        finder = CoordinateFinder.new(postcode: "WC2B 6NH")
        allow(finder).to receive(:get_content) { response }

        coordinates = finder.coordinates

        expect(coordinates[:lat]).to eq(51.51695998250193)
        expect(coordinates[:lng]).to eq(-0.12060134310237684)
       end
     end
  end
end
