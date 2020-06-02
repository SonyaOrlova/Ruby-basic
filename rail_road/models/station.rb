# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation_checker'

class Station
  include InstanceCounter
  include ValidationChecker

  attr_reader :name, :trains

  class << self
    attr_accessor :stations
  end

  @stations = {}

  def self.all
    stations
  end

  def initialize(name)
    @name = name

    validate!

    register_instance

    self.class.stations[name] = self

    @trains = []
  end

  def each_train
    @trains.each { |train| yield train }
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def _add_train(train)
    @trains << train
  end

  def _remove_train(train)
    @trains.delete(train)
  end

  def validate!
    raise ArgumentError, 'duplicate_name' if self.class.stations[@name]
  end
end
