require_relative '../modules/manufacturer'

class Wagon
  include Manufacturer

  attr_reader :id, :type, :train

  def initialize(id, type = nil)
    @id = id
    @type = type

    @train = nil
  end

  def _attach_to(train)
    @train = train
  end

  def _unhook()
    @train = nil
  end
end