# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/accessors'

class Station
  extend Accessors

  include InstanceCounter

  attr_reader :name, :trains

  attr_accessor_with_history :a, :b
  strong_attr_accessor :c, String

  class << self
    attr_accessor :stations
  end

  @stations = {}

  def self.all
    stations
  end

  def initialize(name)
    @name = name

    custom_validate!

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

  def custom_validate!
    raise ArgumentError, 'duplicate_name' if self.class.stations[@name]
  end
end
