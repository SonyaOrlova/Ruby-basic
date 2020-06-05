# frozen_string_literal: true

require_relative '../models/station'

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :id, :from, :to, :way_stations

  validate :from, :type, Station
  validate :to, :type, Station

  def initialize(from, to)
    @from = from
    @to = to

    validate!
    custom_validate!

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

  def custom_validate!
    raise ArgumentError, 'duplicate_station' if @from == @to
  end
end
