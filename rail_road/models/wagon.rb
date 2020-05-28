require_relative '../modules/manufacturer'
require_relative '../modules/validation_checker'

class Wagon
  include Manufacturer
  include ValidationChecker

  attr_reader :id, :type, :train

  TYPES = ['cargo', 'passenger']

  def initialize(id, type = nil)
    @id = id
    @type = type

    validate!

    @train = nil
  end

  def _attach_to(train)
    @train = train
  end

  def _unhook()
    @train = nil
  end

  def validate!
    raise ArgumentError, 'incorrect_type' if !(TYPES.include? @type)
  end
end