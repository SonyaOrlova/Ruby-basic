# frozen_string_literal: true

require_relative '../modules/manufacturer'
require_relative '../modules/instance_counter'
require_relative '../modules/validation_checker'

class Train
  include InstanceCounter
  include Manufacturer
  include ValidationChecker

  attr_reader :id, :type, :route, :wagons, :speed

  ID_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze
  TYPES = %w[cargo passenger].freeze

  # rubocop:disable Style/ClassVars
  @@trains = {}
  # rubocop:enable Style/ClassVars

  def self.find(id)
    @@trains[id]
  end

  def initialize(id, type = nil)
    @id = id
    @type = type

    validate!

    register_instance

    @@trains[id] = self

    @wagons = []
    @speed = 0
  end

  def add_route(route)
    @route = route

    @current_station_index = 0

    move(@current_station_index)
  end

  def current_station
    get_station(@current_station_index)
  end

  def next_station
    get_station(next_station_index)
  end

  def prev_station
    get_station(prev_station_index)
  end

  def move_next_station
    move(next_station_index)
  end

  def move_prev_station
    move(prev_station_index)
  end

  def speed_up
    @speed = max_speed
  end

  def speed_down
    @speed = 0
  end

  def add_wagon(wagon)
    raise ArgumentError, 'incorrect_type' if wagon.type != @type
    raise ArgumentError, 'nonzero_speed' if @speed != 0

    wagon._attach_to(self)

    @wagons << wagon
  end

  def remove_wagon(wagon)
    raise StandardError 'nonzero_speed' if @speed != 0

    wagon._unhook

    @wagons.delete(wagon)
  end

  def each_wagon
    @wagons.each { |wagon| yield wagon }
  end

  protected

  def max_speed
    500
  end

  private

  def next_station_index
    @current_station_index + 1 if @current_station_index && @current_station_index != @route.stations.length - 1
  end

  def prev_station_index
    @current_station_index - 1 if @current_station_index && @current_station_index != 0
  end

  def get_station(station_index)
    station_index && @route.stations[station_index]
  end

  def move(station_index)
    return unless station_index

    station_from = @route.stations[@current_station_index]
    station_to = @route.stations[station_index]

    station_from._remove_train(self)
    station_to._add_train(self)

    @current_station_index = station_index
  end

  def validate!
    raise ArgumentError, 'incorrect_id' unless @id =~ ID_FORMAT
    raise ArgumentError, 'incorrect_type' unless TYPES.include? @type
  end
end
