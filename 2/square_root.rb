print 'Введите 1й коэффициент: '
a = gets.chomp.to_f

print 'Введите 2й коэффициент: '
b = gets.chomp.to_f

print 'Введите 3й коэффициент: '
c = gets.chomp.to_f

d = b ** 2 - 4 * a * c

print "Дискриминант равен #{d}; "

if d > 0
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)

  puts "Корни равны #{x1} и #{x2}"
elsif d == 0
  x = -b / (2 * a)

  puts "Корень равен #{x}"
else
  puts "Корней нет"
end
