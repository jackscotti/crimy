require 'coordinate_finder'

#TODO: move these requires to the helper
require 'httparty'
require 'pry'

describe "#coordinates" do
  #TODO: mock Mapit API response
  context "providing a postcode" do
    context "Mapit does not find the postcode" do
      it "raises an error" do
        finder = CoordinateFinder.new(postcode: "XXXX")

        expect { finder.coordinates }.to raise_error "Not a valid or complete postcode inserted"
      end
    end
    context "Mapit finds the postcode" do
      it "returns lat and long" do
        finder = CoordinateFinder.new(postcode: "WC2B 6NH")
        coordinates = finder.coordinates

        expect(coordinates[:lat]).to eq(51.51695998250193)
        expect(coordinates[:lng]).to eq(-0.12060134310237684)
       end
     end
  end
end
