class Route
  attr_reader :id, :from, :to, :way_stations

  def initialize(from, to)
    @from = from
    @to = to

    @id = "#{from.name}-#{to.name}"

    @way_stations = []
  end

  def add_station(station)
    @way_stations << station
  end

  def remove_station(station)
    @way_stations.delete(station)
  end

  def stations
    [@from] + @way_stations + [@to]
  end
end
