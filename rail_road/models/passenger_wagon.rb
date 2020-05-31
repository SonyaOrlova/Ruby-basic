class PassengerWagon < Wagon
  attr_reader :available_seats_count, :occupied_seats_count

  def initialize(id, seats_count)
    super(id, 'passenger', seats_count)
  end

  def occupy_place(seats = 1)
    super(seats)
  end
end