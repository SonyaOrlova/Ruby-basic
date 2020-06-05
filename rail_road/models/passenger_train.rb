# frozen_string_literal: true

require_relative '../modules/validation'

class PassengerTrain < Train
  include Validation

  validate :id, :format, ID_FORMAT

  def initialize(id)
    super(id, 'passenger')
  end

  protected

  def max_speed
    250
  end
end
