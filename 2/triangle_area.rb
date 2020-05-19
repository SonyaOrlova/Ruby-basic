print "Введите длину основания треугольника: "
a = gets.chomp.to_f

print "Введите высоту треугольника: "
h = gets.chomp.to_f

triangle_area = 0.5 * a * h

puts "Площадь треугольника равна #{triangle_area}"
