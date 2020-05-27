class Train
  attr_reader :id, :type, :route, :wagons, :speed

  def initialize(id, type = nil)
    @id = id
    @type = type

    @wagons = []

    @speed = 0
  end

  def add_route(route)
    @route = route

    @current_station_index = 0

    move(@current_station_index)
  end

  def current_station
    get_station(@current_station_index)
  end
  
  def next_station
    get_station(next_station_index)
  end

  def prev_station
    get_station(prev_station_index)
  end

  def move_next_station
    move(next_station_index)
  end

  def move_prev_station
    move(prev_station_index)
  end

  def speed_up
    @speed = max_speed
  end

  def speed_down
    @speed = 0
  end

  def add_wagon(wagon)
    raise StandardError, 'incorrect_type' if wagon.type != @type
    raise StandardError, 'nonzero_speed' if @speed != 0

    wagon._attach_to(self)

    @wagons << wagon
  end

  def remove_wagon(wagon)
    raise 'nonzero_speed' if @speed != 0

    wagon._unhook()

    @wagons.delete(wagon) 
  end

  protected # доступны из подклассов

  def max_speed
    500
  end

  private # не доступны
  
  def next_station_index
    @current_station_index + 1 if @current_station_index && @current_station_index != @route.stations.length - 1
  end

  def prev_station_index
    @current_station_index - 1 if @current_station_index && @current_station_index != 0
  end

  def get_station(station_index)
    station_index && @route.stations[station_index]
  end

  def move(station_index)
    return unless station_index

    station_from = @route.stations[@current_station_index]
    station_to = @route.stations[station_index]

    station_from._remove_train(self)
    station_to._add_train(self)

    @current_station_index = station_index
  end
end
