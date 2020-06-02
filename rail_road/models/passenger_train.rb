# frozen_string_literal: true

class PassengerTrain < Train
  def initialize(id)
    super(id, 'passenger')
  end

  protected

  def max_speed
    250
  end
end
