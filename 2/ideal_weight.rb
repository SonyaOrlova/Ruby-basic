print "Введите Ваше имя: "
name = gets.chomp.capitalize

print "Введите Ваш рост: "
height = gets.chomp.to_i

ideal_weight = (height - 110) * 1.15

puts ideal_weight < 0 ? "#{name}, Ваш вес уже оптимальный" : "#{name}, Ваш оптимальный вес #{ideal_weight}"
