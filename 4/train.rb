class Train
  attr_reader :id, :type, :wagons_count, :speed

  def initialize(id, type, wagons_count)
    @id = id
    @type = type
    @wagons_count = wagons_count

    @speed = 0
  end

  def add_route(route)
    @stations = route.stations

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

  MAX_SPEED = 500

  def speed_up
    @speed = MAX_SPEED
  end

  def speed_down
    @speed = 0
  end

  def add_wagon
    @wagons_count += 1 if speed == 0
  end

  def remove_wagon
    @wagons_count -= 1 if speed == 0 && @wagons_count > 0
  end

  private
  
  def next_station_index
    @current_station_index + 1 if @current_station_index && @current_station_index != @stations.length - 1
  end

  def prev_station_index
    @current_station_index - 1 if @current_station_index && @current_station_index != 0
  end

  def get_station(station_index)
    station_index && @stations[station_index]
  end

  def move(station_index)
    return unless station_index

    station_from = @stations[@current_station_index]
    station_to = @stations[station_index]

    station_from.remove_train(self)
    station_to.add_train(self)

    @current_station_index = station_index
  end
end
