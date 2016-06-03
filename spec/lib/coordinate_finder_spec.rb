require 'coordinate_finder'
require 'spec_helper'

# Warning: These tests could pass if MapIt changed its API.
describe "#coordinates" do
  context "providing a postcode" do
    context "Mapit does not find the postcode" do
      it "raises an error" do
        error_message = "Postcode 'not a postcode' is not valid."
        response = {
          "code" => 400,
          "error" => error_message,
        }

        finder = CoordinateFinder.new(postcode: "not a postcode")
        allow(finder).to receive(:get_content) { response }

        expect { finder.coordinates }.to raise_error error_message
      end
    end
    context "Mapit finds the postcode" do
      it "returns lat and long" do
        response = {
          "wgs84_lat" => 51.00,
          "wgs84_lon" => -0.12,
          "postcode" => "V4L 1D",
        }

        finder = CoordinateFinder.new(postcode: "V4L 1D")
        allow(finder).to receive(:get_content) { response }

        coordinates = finder.coordinates

        expect(coordinates[:lat]).to eq(51.00)
        expect(coordinates[:lng]).to eq(-0.12)
       end
     end
  end
end
