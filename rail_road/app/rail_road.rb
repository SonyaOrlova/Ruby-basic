require_relative "../models/station"
require_relative "../models/route"
require_relative "../models/train"
require_relative "../models/cargo_train"
require_relative "../models/passenger_train"
require_relative "../models/wagon"
require_relative "../models/cargo_wagon"
require_relative "../models/passenger_wagon"

COLOR_CODES = {
  red: 31,
  green: 32,
  yellow: 33,
  pink: 35,
  blue: 36
}

class RailRoad
  def initialize
    @stations = []
    @routes = []
    @trains = []
    @wagons = []

    # Стабы

    # s1 = Station.new("s1")
    # s2 = Station.new("s2")
    # s3 = Station.new("s3")
    # s4 = Station.new("s4")

    # r1 = Route.new(s1,s2)
    # r2 = Route.new(s3,s4)

    # wc1 = CargoWagon.new("wc1")
    # wc2 = CargoWagon.new("wc2")
    # wp1 = PassengerWagon.new("wp1")
    # wp2 = PassengerWagon.new("wp2")

    # tc1 = CargoTrain.new("tc1")
    # tc2 = CargoTrain.new("tc2")
    # tc2.add_route(r1)
    # tc2.add_wagon(wc1)

    # tp1 = PassengerTrain.new("tp1")
    # tp2 = PassengerTrain.new("tp2")
    # tp2.add_route(r2)
    # tp2.add_wagon(wp1)

    # @stations = [s1,s2,s3,s4]
    # @routes = [r1, r2]
    # @wagons = [wc1,wc2,wp1,wp2]
    # @trains = [tc1,tc2,tp1,tp2]
  end

  def show_menu_main
    puts colorize("Главное меню", :blue)
    puts "Введите 1, если хотите перейти в блок 'Станции'"
    puts "Введите 2, если хотите перейти в блок 'Маршруты'"
    puts "Введите 3, если хотите перейти в блок 'Поезда'"
    puts "Введите 4, если хотите перейти в блок 'Вагоны'"
    puts "Введите 0 или другое значение, если хотите выйти из программы"

    answer = gets.chomp

    case answer
      when '1'
        show_menu_stations
      when '2'
        show_menu_routes
      when '3'
        show_menu_trains
      when '4'
        show_menu_wagons
      else
        return
    end
  end

  def show_menu_stations
    actions = {
      create: lambda { create_stations },
      review: lambda { review_stations }
    }

    show_menu_block("Станции", actions)
  end

  def show_menu_routes
    actions = {
      create: lambda { create_routes },
      manage: lambda { manage_routes },
      review: lambda { review_routes }
    }

    show_menu_block("Маршруты", actions)
  end

  def show_menu_trains
    actions = {
      create: lambda { create_trains },
      manage: lambda { manage_trains },
      review: lambda { review_trains }
    }

    show_menu_block("Поезда", actions)
  end

  def show_menu_wagons
    actions = {
      create: lambda { create_wagons },
      manage: lambda { manage_wagons },
      review: lambda { review_wagons }
    }

    show_menu_block("Вагоны", actions)
  end

  def create_stations
    show_submenu_block(
      "Станции",
      "Введите название станции, которую хотите создать"
    ) do |result|
      begin
        station = Station.new(result)
      rescue ArgumentError => e
        if (e.message == 'duplicate_name')
          puts colorize("Такая станция уже существует", :red)
        else
          raise
        end
      else
        @stations << station
        puts colorize("Создана станция #{result}", :green)
      end
    end
  end

  def create_routes
    if @stations.length < 2
      puts colorize("Перед созданием маршрута, необходимо создать минимум 2 станции", :red)
      show_menu_routes
      return
    end

    show_submenu_block(
      "Маршруты",
      "Введите названия начальной и конечной станций маршрута через запятую. Доступные станции: #{inspect(:@name, @stations)}",
    ) do |result|
      from, to = result.split(",")

      from = @stations.detect { |station| station.name == from }
      to = @stations.detect { |station| station.name == to }

      if !from
        puts colorize("Введено несуществующее название начальной станции. Попробуйте еще раз.", :red)
        next
      end

      if !to
        puts colorize("Введено несуществующее название конечной станции. Попробуйте еще раз.", :red)
        next
      end

      begin
        route = Route.new(from, to)
      rescue ArgumentError => e
        if (e.message == 'duplicate_station')
          puts colorize("Начальная и конечная станции не должны совпадать", :red)
        else
          raise
        end
      else
        @routes << route
        puts colorize("Создан маршрут #{route.id} со станциями #{inspect(:@name, [route.from, route.to])}", :green)
      end
    end
  end

  def create_trains
    typeMap = Hash.new({
      type: 'another',
      ru: 'прочий',
      class_item: Train
    })

    typeMap['c'] = {
      type: 'cargo',
      ru: 'грузовой',
      class_item: CargoTrain
    }

    typeMap['p'] = {
      type: 'passenger',
      ru: 'пассажирский',
      class_item: PassengerTrain
    }

    show_submenu_block(
      "Поезда",
      "Введите идентификатор поезда и его тип ('c' = #{typeMap['c'][:ru]}, 'p' = #{typeMap['p'][:ru]}) через запятую",
    ) do |result|
      id, type = result.split(",")

      is_dublicated = Train.find(id)

      if is_dublicated
        puts colorize("Поезд с идентификатором #{id} уже существует", :red)
        next
      end

      begin
        train = typeMap[type][:class_item].new(id)
      rescue ArgumentError => e
        case e.message
          when 'incorrect_id'
            puts colorize("Введен некорректный формат идентификатора поезда", :red)
          when 'incorrect_type'
            puts colorize("Введен некорректный тип поезда", :red)
          else
            raise
        end
      else
        @trains << train
        puts colorize("Создан #{typeMap[type][:ru]} поезд с идентификатором #{train.id}", :green)
      end
    end
  end

  def create_wagons
    typeMap = Hash.new({
      type: 'another',
      ru: 'прочий',
      class_item: Wagon
    })

    typeMap['c'] = {
      type: 'cargo',
      ru: 'грузовой',
      class_item: CargoWagon
    }

    typeMap['p'] = {
      type: 'passenger',
      ru: 'пассажирский',
      class_item: PassengerWagon
    }

    show_submenu_block(
      "Вагоны",
      "Введите идентификатор вагона, его тип ('c' = #{typeMap['c'][:ru]}, 'p' = #{typeMap['p'][:ru]}), и кол-во мест для пассажирского вагона/объем для грузового через запятую",
    ) do |result|
      id, type, property = result.split(",")

      if !id || !type || !property
        puts colorize("Введены не все данные. Попробуйте еще раз", :red)
        next
      end

      begin
        wagon = typeMap[type][:class_item].new(id, property.to_i)
      rescue ArgumentError => e
        if e.message == 'incorrect_type'
          puts colorize("Введен некорректный тип вагона", :red)
        else
          raise
        end
      else
        @wagons << wagon
        puts colorize("Создан #{typeMap[type][:ru]} вагон с идентификатором #{wagon.id}", :green)
      end
    end
  end

  def review_stations
    show_submenu_block(
      "Станции",
      "Введите название станции, о которой хотите просмотреть информацию",
      true
    ) do |result|
      station = @stations.detect { |station| station.name == result }

      if !station
        puts colorize("Введено несуществующее имя станции. Попробуйте еще раз", :red)
        next
      end

      puts colorize("Информация о станции #{station.name}:", :green)

      if station.trains.length > 0
        typeMap = { 'cargo' => 'грузовой', 'passenger' => 'пассажирский'}

        puts colorize("* поезда на станции:", :green)

        station.each_train { |train| puts colorize("поезд с идентификатором #{train.id}, типом #{typeMap[train.type]}, кол-во вагонов #{train.wagons.length}", :green) }
      else
        puts colorize("* на станции нет поездов", :red)
      end
    end
  end

  def review_routes
    show_submenu_block(
      "Маршруты",
      "Введите идентификатор маршрута, о котором хотите просмотреть информацию",
      true
    ) do |result|
      route = @routes.detect { |route| route.id == result }

      if !route
        puts colorize("Введено несуществующий идентификатор маршрута. Попробуйте еще раз", :red)
        next
      end

      inspect_route(route, :green)
    end
  end

  def review_trains
    show_submenu_block(
      "Поезда",
      "Введите идентификатор поезда, о котором хотите просмотреть информацию",
      true
    ) do |result|
      train = @trains.detect { |train| train.id == result }

      if !train
        puts colorize("Введено несуществующий идентификатор поезда. Попробуйте еще раз", :red)
        next
      end

      inspect_train(train, :green)
    end
  end

  def review_wagons
    show_submenu_block(
      "Вагоны",
      "Введите идентификатор вагона, о котором хотите просмотреть информацию",
      true
    ) do |result|
      wagon = @wagons.detect { |wagon| wagon.id == result }

      if !wagon
        puts colorize("Введен несуществующий идентификатор вагона. Попробуйте еще раз", :red)
        next
      end

      inspect_wagon(wagon, :green)
    end
  end

  def manage_routes
    show_submenu_block(
      "Маршруты",
      "Введите идентификатор маршрута, в который необходимо внести изменения",
      true
    ) do |result|
      route = @routes.detect { |route| route.id == result }

      if !route
        puts colorize("Введен несуществующий идентификатор маршрута. Попробуйте еще раз", :red)
        next
      end

      inspect_route(route, :pink)

      puts "Введите 1, если хотите добавить станции в маршрут"
      puts "Введите 2, если хотите удалить станции из маршрута"
      puts "Введите 0 или другое значение, если хотите вернуться в меню блока 'Маршруты'"

      result = gets.chomp

      case result
        when '1'
          add_station_to_route(route)
        when '2'
          remove_station_from_route(route)
        else
          show_menu_routes
          break
        end
    end
  end

  def manage_trains
    show_submenu_block(
      "Поезда",
      "Введите идентификатор поезда, в который необходимо внести изменения",
      true
    ) do |result|
      typeMap = { 'cargo' => 'грузовой', 'passenger' => 'пассажирский'}

      train = @trains.detect { |train| train.id == result }

      if !train
        puts colorize("Введен несуществующий идентификатор поезда. Попробуйте еще раз", :red)
        next
      end

      inspect_train(train, :pink)

      puts "Введите 1, если хотите добавить маршрут"
      puts "Введите 2, если хотите привести поезд в движение"
      puts "Введите 3, если хотите остановить поезд"
      puts "Введите 4, если хотите переместить на следующую станцию"
      puts "Введите 5, если хотите переместить на предыдущую станцию"
      puts "Введите 6, если хотите добавить вагоны"
      puts "Введите 7, если хотите удалить вагоны"
      puts "Введите 0 или другое значение, если хотите вернуться в меню блока 'Поезда'"

      result = gets.chomp

      case result
        when '1'
          add_route_to_train(train)
        when '2'
          speed_up_train(train)
        when '3'
          speed_down_train(train)
        when '4'
          move_train_to_next_station(train)
        when '5'
          move_train_to_prev_station(train)
        when '6'
          add_wagon_to_train(train)
        when '7'
          remove_wagon_from_train(train)
        else
          show_menu_trains
          break
        end
    end
  end

  def manage_wagons
    show_submenu_block(
      "Вагоны",
      "Введите идентификатор вагона, в который необходимо внести изменения",
      true
    ) do |result|
      wagon = @wagons.detect { |wagon| wagon.id == result }

      if !wagon
        puts colorize("Введен несуществующий идентификатор вагона. Попробуйте еще раз", :red)
        next
      end

      inspect_wagon(wagon, :pink)

      puts "Введите 1, если хотите занять свободный объем" if wagon.type == 'cargo'
      puts "Введите 1, если хотите занять свободное место" if wagon.type == 'passenger'
      puts "Введите 0 или другое значение, если хотите вернуться в меню блока 'Вагоны'"

      result = gets.chomp

      case result
        when '1'
          if wagon.type == 'cargo'
           puts colorize("Введите кол-во объема, которое хотите занять в вагоне", :yellow)

           volume = gets.chomp.to_i
          end

          begin
            wagon.occupy_place(volume) if wagon.type == 'cargo'
            wagon.occupy_place if wagon.type == 'passenger'
          rescue ArgumentError => e
            if e.message == 'no_available_place'
              puts colorize("Невозможно занять указанное кол-во объема, свободно - #{wagon.available_place}", :red) if wagon.type == 'cargo'
              puts colorize("Невозможно занять место, свободных мест нет", :red) if wagon.type == 'passenger'
            else
              raise
            end
          else
            puts colorize("Вы заняли #{volume} объема", :green) if wagon.type == 'cargo'
            puts colorize("Кол-во занятого объема - #{wagon.occupied_place}, кол-во свободного объема - #{wagon.available_place}", :pink) if wagon.type == 'cargo'

            puts colorize("Вы заняли место", :green) if wagon.type == 'passenger'
            puts colorize("Кол-во занятых мест - #{wagon.occupied_place}, кол-во свободных мест - #{wagon.available_place}", :pink) if wagon.type == 'passenger'
          end
        else
          show_menu_wagons
          break
        end
    end
  end

  private

  def show_menu_block(block_name, actions)
    is_managed = actions.has_key?(:manage)

    map = {}

    puts colorize("Блок #{block_name}", :blue)

    actions.each.with_index(1) do |(type, lamda), index|
      map[index] = type

      case type
        when :create
          puts "Введите #{index}, если хотите создать новый элемент"
        when :manage
          puts "Введите #{index}, если хотите управлять текущими элементами"
        when :review
          puts "Введите #{index}, если хотите ознакомиться с текущими элементами"
      end
    end

    puts "Введите 0 или другое значение, если хотите вернуться в главное меню"

    answer = gets.chomp.to_i

    action = actions[map[answer]]

    action ? action.call : show_menu_main
  end

  def show_submenu_block(block_name, command, return_if_empty = false)
    block_map = {
      "Станции" => {
        items: @stations,
        inspect_param: :@name, 
        block_menu_clb: lambda { show_menu_stations }
      },
      "Маршруты" => {
        items: @routes,
        inspect_param: :@id, 
        block_menu_clb: lambda { show_menu_routes }
      },
      "Поезда" => {
        items: @trains,
        inspect_param: :@id, 
        block_menu_clb: lambda { show_menu_trains }
      },
      "Вагоны" => {
        items: @wagons,
        inspect_param: :@id, 
        block_menu_clb: lambda { show_menu_wagons }
      }
    }

    items = block_map [block_name][:items]
    inspect_param = block_map [block_name][:inspect_param]
    block_menu_clb = block_map [block_name][:block_menu_clb]

    if return_if_empty && items.length == 0
      puts colorize("Элементы блока #{block_name} не созданы", :red)
      block_menu_clb.call
      return
    end

    on_continue = nil

    catch :done do
      loop do
        puts colorize("Текущие элементы блока #{block_name}: #{inspect(inspect_param, items)}", :pink) if items.length > 0

        puts colorize(command, :yellow) if command
        puts "Введите 1, если хотите вернуться в меню блока #{block_name}" 
        puts "Введите 0, если хотите вернуться в главное меню"

        result = gets.chomp

        case result
          when '1'
            on_continue = block_menu_clb
            break
          when '0'
            on_continue = lambda { show_menu_main }
            break
          else
            on_continue = block_menu_clb

            yield(result) if block_given?
          end
      end
    end

    puts colorize("Элементы блока #{block_name} не созданы", :red) if items.length == 0

    on_continue.call
  end

  def inspect_route(route, color)
    puts colorize("Информация о маршруте #{route.id}:", color)
    puts colorize("* станции - #{inspect(:@name, route.stations)}", color)
  end

  def inspect_train(train, color)
    typeMap = { 'cargo' => 'грузовой', 'passenger' => 'пассажирский'}

    puts colorize("Информация о поезде #{train.id}:", color)
    puts colorize("* тип - #{typeMap[train.type]}", color)

    if train.route
      puts colorize("* маршрут #{train.route.id}, со станциями - #{inspect(:@name, train.route.stations)}", color)
    else
      puts colorize("* маршрут - не присвоен", color)
    end

    puts colorize("* текущая скорость - #{train.speed}", color)

    puts colorize("* текущая станция - #{train.current_station.name}", color) if train.current_station
    puts colorize("* следующая станция - #{train.next_station.name}", color) if train.next_station
    puts colorize("* предыдущая станция - #{train.prev_station.name}", color) if train.prev_station

    if train.wagons.length > 0
      puts colorize("* вагоны:", color)

      train.each_wagon { |wagon| inspect_wagon(wagon, color) }
    else
      puts colorize("* вагоны - отсутствуют", color)
    end
  end

  def inspect_wagon(wagon, color)
    typeMap = { 'cargo' => 'грузовой', 'passenger' => 'пассажирский'}

    puts colorize("Информация о вагоне #{wagon.id}:", color)
    puts colorize("* тип - #{typeMap[wagon.type]}", color)

    if wagon.train
      puts colorize("* прицеплен к поезду - #{wagon.train.id}", color)
    else
      puts colorize("* вагон свободен", :red)
    end

    puts colorize("* кол-во занятого объема - #{wagon.occupied_place}, кол-во свободного объема - #{wagon.available_place}", color) if wagon.type == 'cargo'
    puts colorize("* кол-во занятых мест - #{wagon.occupied_place}, кол-во свободных мест - #{wagon.available_place}", color) if wagon.type == 'passenger'
  end

  def add_station_to_route(route)
    loop do
      available_stations = @stations.select { |station| !(route.stations.include? station) }

      if available_stations.length == 0
        puts colorize("Нет доступных станций к добавлению", :red)
        break
      end

      puts colorize("Доступные станции к добавлению: #{inspect(:@name, available_stations)}", :pink)
      puts colorize("Введите название станции, которую нужно добавить в маршрут", :yellow)
      puts "Введите 1, если хотите вернуться в меню управления маршрутами"
      puts "Введите 0, если хотите вернуться в меню блока 'Маршруты'"

      result = gets.chomp

      case result
        when '1'
          break
        when '0'
          throw :done
        else
          station = available_stations.detect { |station| station.name == result }

          if station
            route.add_station(station)
            puts colorize("Станция #{station.name} добавлена в маршрут #{route.id}", :green)
            puts colorize("Итого станции в маршруте #{route.id}: #{inspect(:@name, route.stations)}", :pink)
          else
            puts colorize("Введено некорректное имя станции. Попробуйте еще раз", :red)
            next
          end
      end
    end
  end

  def remove_station_from_route(route)
    loop do
      way_stations = route.way_stations

      if way_stations.length == 0
        puts colorize("Нет промежуточных станций к удалению из маршрута #{route.id}", :red)
        break
      end

      puts colorize("Доступные станции к удалению: #{inspect(:@name, way_stations)} из маршрута #{route.id}", :pink)
      puts colorize("Введите название станции, которую нужно удалить из в маршрута #{route.id}", :yellow)
      puts "Введите 1, если хотите вернуться в меню управления маршрутами"
      puts "Введите 0, если хотите вернуться в меню блока 'Маршруты'"

      result = gets.chomp

      case result
        when '1'
          break
        when '0'
          throw :done
        else
          station = way_stations.detect { |station| station.name == result }

          if station
            route.remove_station(station)
            puts colorize("Станция #{station.name} удалена из маршрута #{route.id}", :green)
            puts colorize("Итого станции в маршруте #{route.id}: #{inspect(:@name, route.stations)}", :pink)
          else
            puts colorize("Введено некорректное имя станции. Попробуйте еще раз", :red)
            next
          end
      end
    end
  end

  def add_route_to_train(train)
    loop do
      if train.route
        puts colorize("Поезду #{train.id} уже присвоен маршрут #{train.route.id}", :green)
      else
        puts colorize("Поезду #{train.id} пока не присвоен маршрут", :red)
      end

      available_routes = @routes.select { |route| route != train.route }

      if available_routes.length == 0
        puts colorize("Доступные маршруты отсутствуют", :red)
        break
      end

      puts colorize("Доступные маршруты: #{inspect(:@id, available_routes)}", :pink)

      puts colorize("Введите идентификатор маршрута, который хотите присвоить поезду #{train.id}", :yellow)
      puts "Введите 1, если хотите вернуться в меню управления поездами"
      puts "Введите 0, если хотите вернуться в меню блока 'Поезда'"

      result = gets.chomp

      case result
        when '1'
          break
        when '0'
          throw :done
        else
          route = available_routes.detect { |route| route.id == result }

          if route
            train.add_route(route)
            puts colorize("Маршрут #{route.id} со станциями #{inspect(:@name, route.stations)} присвоен поезду #{train.id}", :green)
          else
            puts colorize("Введено некорректный идентификатор маршрута. Попробуйте еще раз", :red)
            next
          end
      end
    end
  end

  def speed_up_train(train)
    if train.speed > 0
      puts colorize("Поезд #{train.id} уже находится в движении. Текущая скорость - #{train.speed}", :red)
    else
      train.speed_up
      puts colorize("Поезд #{train.id} приведен в движение. Текущая скорость - #{train.speed}", :green)
    end
  end

  def speed_down_train(train)
    if train.speed == 0
      puts colorize("Поезд #{train.id} уже остановлен. Текущая скорость - #{train.speed}", :red)
    else
      train.speed_down
      puts colorize("Поезд #{train.id} остановлен. Текущая скорость - #{train.speed}", :green)
    end
  end

  def move_train_to_next_station(train)
    if !train.route
      puts colorize("Поезду #{train.id} не присвоен маршрут", :red)
    elsif !train.next_station
      puts colorize("Поезд #{train.id} невозможно переместить на следующую станцию. Текущая станция поезда #{train.current_station.name} - конечная", :red)
    else
      train.move_next_station
      puts colorize("Поезд #{train.id} перемещен на станцию - #{train.current_station.name}", :green)
    end
  end

  def move_train_to_prev_station(train)
    if !train.route
      puts colorize("Поезду #{train.id} не присвоен маршрут", :red)
    elsif !train.prev_station
      puts colorize("Поезд #{train.id} невозможно переместить на предыдущую станцию. Текущая станция поезда #{train.current_station.name} - начальная", :red)
    else
      train.move_prev_station
      puts colorize("Поезд #{train.id} перемещен на станцию - #{train.current_station.name}", :green)
    end
  end

  def add_wagon_to_train(train)
    loop do
      if train.wagons.length > 0
        puts colorize("К поезду #{train.id} прицеплены вагоны - #{inspect(:@id, train.wagons)}", :pink)
      else
        puts colorize("У поезда #{train.id} пока нет вагонов", :red)
      end

      available_wagons = @wagons.select { |wagon| !wagon.train }

      if available_wagons.length == 0
        puts colorize("Свободные вагоны отсутствуют", :red)
        break
      end

      puts colorize("Свободные вагоны: #{inspect(:@id, available_wagons)}", :pink)

      puts colorize("Введите идентификатор вагона, который вы хотите прицепить к поезду #{train.id}", :yellow)
      puts "Введите 1, если хотите вернуться в меню управления поездами"
      puts "Введите 0, если хотите вернуться в меню блока 'Поезда'"

      result = gets.chomp

      case result
        when '1'
          break
        when '0'
          throw :done
        else
          wagon = available_wagons.detect { |wagon| wagon.id == result }

          if wagon
            begin
              train.add_wagon(wagon)
            rescue ArgumentError => e
              typeMap = { 'cargo' => 'грузовой', 'passenger' => 'пассажирский'}

              case e.message
                when 'incorrect_type'
                  puts colorize("Некорректный тип вагона - #{typeMap[wagon.type]}. К поезду #{train.id} возможно прицепить только вагон с типом #{typeMap[train.type]}", :red)
                when 'nonzero_speed'
                  puts colorize("Невозможно прицепить вагон, поезд #{train.id} находится в движении, текущая скорость - #{train.speed}", :red)
                else
                  raise
              end
            else
              puts colorize("Вагон #{wagon.id} прицеплен к поезду #{train.id}", :green)
            end
          else
            puts colorize("Введено некорректный идентификатор вагона. Попробуйте еще раз", :red)
            next
        end
      end
    end
  end

  def remove_wagon_from_train(train)
    loop do
      if train.wagons.length > 0
        puts colorize("К поезду #{train.id} прицеплены вагоны - #{inspect(:@id, train.wagons)}", :pink)
      else
        puts colorize("У поезда #{train.id} пока нет вагонов", :red)
        break
      end

      available_wagons = train.wagons

      puts colorize("Введите идентификатор вагона, который вы хотите отцепить от поезда #{train.id}", :yellow)
      puts "Введите 1, если хотите вернуться в меню управления поездами"
      puts "Введите 0, если хотите вернуться в меню блока 'Поезда'"

      result = gets.chomp

      case result
        when '1'
          break
        when '0'
          throw :done
        else
          wagon = available_wagons.detect { |wagon| wagon.id == result }

          if wagon
            begin
              train.remove_wagon(wagon)
            rescue => e
              if (e.message == 'nonzero_speed')
                puts colorize("Невозможно отцепить вагон, поезд #{train.id} находится в движении, текущая скорость - #{train.speed}", :red)
              else
                raise
              end
            else
              puts colorize("Вагон #{wagon.id} отцеплен от поезда #{train.id}", :green)
            end
          else
            puts colorize("Введено некорректный идентификатор вагона. Попробуйте еще раз", :red)
            next
          end
      end
    end
  end

  def inspect(param, items)
    result = ""

    items.each { |item| result << "#{item.instance_variable_get(param)},"}

    result.rstrip.chop
  end

  def colorize(text, color)
    "\e[#{COLOR_CODES[color]}m#{text}\e[0m"
  end
end
