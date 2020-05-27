require_relative '../modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []

  def initialize(name)
    register_instance

    @@stations << self

    @name = name
    @trains = []
  end

  def self.all
    @@stations
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type}
  end

  def _add_train(train)
    @trains << train 
  end

  def _remove_train(train)
    @trains.delete(train)
  end
end
