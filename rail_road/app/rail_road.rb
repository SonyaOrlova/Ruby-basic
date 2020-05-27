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
      review: lambda { review_wagons }
    }

    show_menu_block("Вагоны", actions)
  end

  def create_stations
    show_submenu_block(
      "Станции",
      "Введите название станции, которую хотите создать"
    ) do |result|
      is_dublicated = @stations.detect {|station| station.name == result }

      if is_dublicated
        puts colorize("Станция с таким названием уже существует", :red)
      else
        @stations << Station.new(result)
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

      if from == to
        puts colorize("Начальная и конечная станции совпадают. Попробуйте еще раз.", :red)
        next
      end

      is_dublicated = @routes.detect {|route| route.id == "#{from.name}-#{to.name}" }

      if is_dublicated
        puts colorize("Такой маршрут уже существует", :red)
      else
        route = Route.new(from, to)
        @routes << route
        puts colorize("Создан маршрут #{route.id} со станциями #{inspect(:@name, [route.from, route.to])}", :green)
      end
    end
  end

  def create_trains
    typeMap = {
      'c' => {
        type: 'cargo',
        ru: 'грузовой',
        class_item: CargoTrain
      },
      'p' => {
        type: 'passenger',
        ru: 'пассажирский',
        class_item: PassengerTrain
      }
    }

    show_submenu_block(
      "Поезда",
      "Введите идентификатор поезда и его тип ('c' = #{typeMap['c'][:ru]}, 'p' = #{typeMap['p'][:ru]}) через запятую",
    ) do |result|
      id, type = result.split(",")

      if !(typeMap.key? type)
        puts colorize("Указан некорректный тип поезда. Попробуйте еще раз", :red)
        next
      end

      is_dublicated = @trains.detect {|train| train.id == id && train.type == typeMap[type][:type] }

      if is_dublicated
        puts colorize("Поезд с идентификатором #{id} и типом #{typeMap[type][:ru]} уже существует", :red)
      else
        train = typeMap[type][:class_item].new(id)
        @trains << train
        puts colorize("Создан #{typeMap[type][:ru]} поезд с идентификатором #{train.id}", :green)
      end
    end
  end

  def create_wagons
    typeMap = {
      'c' => {
        type: 'cargo',
        ru: 'грузовой',
        class_item: CargoWagon
      },
      'p' => {
        type: 'passenger',
        ru: 'пассажирский',
        class_item: PassengerWagon
      }
    }

    show_submenu_block(
      "Вагоны",
      "Введите идентификатор вагона и его тип ('c' = #{typeMap['c'][:ru]}, 'p' = #{typeMap['p'][:ru]}) через запятую",
    ) do |result|
      id, type = result.split(",")

      if !(typeMap.key? type)
        puts colorize("Указан некорректный тип вагона. Попробуйте еще раз", :red)
        next
      end

      is_dublicated = @wagons.detect {|wagon| wagon.id == id && wagon.type == typeMap[type][:type] }

      if is_dublicated
        puts colorize("Вагон с идентификатором #{id} и типом #{typeMap[type][:ru]} уже существует", :red)
      else
        wagon = typeMap[type][:class_item].new(id)
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
        puts colorize("* поезда на станции: #{inspect(:@id, station.trains)}", :green)
        puts colorize("Из них грузовые: #{inspect(:@id, station.trains_by_type("cargo"))}", :green)
        puts colorize("Из них пассажирские: #{inspect(:@id, station.trains_by_type("passenger"))}", :green)
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

      puts colorize("Информация о вагоне #{wagon.id}:", :green)
      puts colorize("* тип - #{typeMap[wagon.type]}", :green)
      if wagon.train
        puts colorize("* прицеплен к поезду - #{wagon.train.id}", :green)
      else
        puts colorize("* вагон свободен", :red)
      end
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

    puts colorize("* текущая станция - #{train.current_station.name}", color) if train.current_station
    puts colorize("* следующая станция - #{train.next_station.name}", color) if train.next_station
    puts colorize("* предыдущая станция - #{train.prev_station.name}", color) if train.prev_station

    if train.wagons.length > 0
      puts colorize("* вагоны в количестве #{train.wagons.length} - #{inspect(:@id, train.wagons)}", color)
    else
      puts colorize("* вагоны - отсутствуют", color)
    end

    puts colorize("* текущая скорость - #{train.speed}", color)
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
            rescue => e
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
              train.add_wagon(wagon)
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
