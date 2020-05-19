print 'Введите длину 1й стороны треугольника: '
a = gets.chomp.to_f

print 'Введите длину 2й стороны треугольника: '
b = gets.chomp.to_f

print 'Введите длину 3й стороны треугольника: '
c = gets.chomp.to_f

triangle = [a, b, c].sort
a, b, c = triangle

is_rectangular = (c ** 2 == a ** 2 + b ** 2)

if is_rectangular
  puts "Треугольник - прямоугольный"
else
  case triangle.uniq.length
    when 1
      puts "Треугольник - равносторонний"
    when 2
      puts "Треугольник - равнобедренный"
    else
      puts "Треугольник - разносторонний"
  end
end
