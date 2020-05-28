require_relative '../modules/instance_counter'
require_relative '../modules/validation_checker'

class Route
  include InstanceCounter
  include ValidationChecker

  attr_reader :id, :from, :to, :way_stations

  def initialize(from, to)
    @from = from
    @to = to

    validate!

    register_instance

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

  def validate!
    raise ArgumentError, 'duplicate_station' if @from == @to
  end
end
