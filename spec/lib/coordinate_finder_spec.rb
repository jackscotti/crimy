require 'coordinate_finder'
require 'spec_helper'

# Warning: These tests could pass even if MapIt changed their API.
describe "#coordinates" do

  context "providing a postcode" do
    context "Mapit does not find the postcode" do
      it "raises an error when postcode is not valid" do
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

  context "Rightmove" do
    let(:url) { "http://www.rightmove.co.uk/property-for-sale/property-XXXXXXXX.html" }
    let(:finder) { CoordinateFinder.new(url: url) }

    it "finds lat and long" do

      response = File.read("spec/fixtures/rightmove-house.html")

      allow(finder).to receive(:get_content) { response }

      coordinates = finder.coordinates

      expect(coordinates[:lat]).to eq("51.50")
      expect(coordinates[:lng]).to eq("-0.16")
    end

    it "does not find lat and long and raise error" do
      response = "an unexpected response that does not contain lat and long data"

      allow(finder).to receive(:get_content) { response }

      expect { finder.coordinates }.to raise_error "whoops, something went wrong!"
    end
  end

  context "Zoopla" do
    xit "finds lat and long" do
    end

    xit "does not find lat and long and raise error" do
    end
  end
end
