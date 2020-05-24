class CargoTrain < Train
  def initialize(id)
    super(id, 'cargo')
  end

  protected

  def max_speed
    100
  end
end