class QueryBuilder
  attr_reader :query_params
  def initialize(query_params)
    @query_params = query_params
  end

  def query
    uri = Addressable::URI.new
    symbolized_params = Hash[query_params.map{ |k, v| [k.to_sym, v] }]
    uri.query_values = CoordinateFinder.new(symbolized_params).coordinates
    uri.query
  end
end
