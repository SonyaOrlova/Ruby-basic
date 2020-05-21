class Route
  attr_reader :from, :to, :way_stations

  def initialize(from, to)
    @from = from
    @to = to

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
