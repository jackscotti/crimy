class QueryBuilder
  def initialize(query_params)
    @query_params = query_params
  end

  def query
    uri = Addressable::URI.new
    uri.query_values = CoordinateFinder.new(@query_params).find
    uri.query
  end
end
