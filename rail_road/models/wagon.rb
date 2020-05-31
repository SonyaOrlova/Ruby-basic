require_relative '../modules/manufacturer'
require_relative '../modules/validation_checker'

class Wagon
  include Manufacturer
  include ValidationChecker

  attr_reader :id, :type, :train, :available_place

  TYPES = ['cargo', 'passenger']

  def initialize(id, type = nil, place = nil)
    @id = id
    @type = type
    @place = place

    validate!

    @train = nil
    @available_place = place
  end

  def _attach_to(train)
    @train = train
  end

  def _unhook()
    @train = nil
  end

  def occupy_place(size)
    available_place = @available_place - size

    raise ArgumentError, 'no_available_place' if available_place < 0

    @available_place = available_place
  end

  def occupied_place
    @place - @available_place
  end

  def validate!
    raise ArgumentError, 'incorrect_type' if !(TYPES.include? @type)
  end
end