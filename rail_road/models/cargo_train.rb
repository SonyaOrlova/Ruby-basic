# frozen_string_literal: true

require_relative '../modules/validation'

class CargoTrain < Train
  include Validation

  validate :id, :format, ID_FORMAT

  def initialize(id)
    super(id, 'cargo')

    validate!
  end

  protected

  def max_speed
    100
  end
end
