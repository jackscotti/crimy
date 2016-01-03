require_relative 'all'

get '/' do
  if params.any?
    redirect to '/crimes?' + QueryBuilder.new(params).query
  else
    erb :index
  end
end

get '/crimes' do
  lat = params['lat']
  lng = params['lng']

  unless lat && lng
    # FIXME: this shows up if a non existing postcode has been provided
    "you must provide <strong>lat</strong> and <strong>lng</strong> in the body of your request"
  else
    finder = CrimeFinder.new(lat: lat, lng: lng)

    erb :crimes, locals: {
      lat: lat,
      lng: lng,
      crimes_at_location: finder.crimes_at_location,
      crimes_1_mile_radious: finder.crimes_within_1_mile_radious,
    }
  end
end
