require_relative '../modules/instance_counter'

class Route
  include InstanceCounter

  attr_reader :id, :from, :to, :way_stations

  def initialize(from, to)
    register_instance

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
