require_relative '../modules/instance_counter'
require_relative '../modules/validation_checker'

class Station
  include InstanceCounter
  include ValidationChecker

  attr_reader :name, :trains

  @@stations = {}

  def initialize(name)
    @name = name

    validate!

    register_instance
    
    @@stations[name] = self

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

  def validate!
    raise ArgumentError, 'duplicate_name' if @@stations[@name]
  end
end
