class CargoWagon < Wagon
  attr_reader :available_volume, :occupied_volume

  def initialize(id, volume)
    super(id, 'cargo', volume)
  end
end