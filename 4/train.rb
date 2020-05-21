class Train
  attr_reader :id, :type, :wagons_count, :speed

  def initialize(id, type, wagons_count)
    @id = id
    @type = type
    @wagons_count = wagons_count

    @speed = 0
  end

  def add_route(route)
    @route = route

    move(0)
  end

  def current_station
    @route.stations[@current_station_index] if @current_station_index
  end
  
  def next_station
    @route.stations[next_station_index] if next_station_index
  end

  def prev_station
    @route.stations[prev_station_index] if prev_station_index
  end

  def move_next_station
    move(next_station_index) if next_station_index
  end

  def move_prev_station
    move(prev_station_index) if prev_station_index
  end

  def speed_up
    @speed = 500
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
    @current_station_index + 1 if @current_station_index && @current_station_index != @route.stations.length - 1
  end

  def prev_station_index
    @current_station_index - 1 if @current_station_index && @current_station_index != 0
  end

  def move(station_index)
    @route.stations[@current_station_index].remove_train(self) if @current_station_index

    @route.stations[station_index].add_train(self)

    @current_station_index = station_index
  end
end
