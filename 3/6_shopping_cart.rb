shopping_cart = {}

loop do
  print "Введите название товара: "
  product_name = gets.chomp

  break if product_name == 'стоп'

  print "Введите стоимость товара за единицу: "
  product_price = gets.chomp.to_f

  print "Введите стоимость кол-во товара: "
  product_count = gets.chomp.to_f

  product_info = { price: product_price, count: product_count, total: product_price * product_count }

  shopping_cart[product_name] = product_info
end

total = shopping_cart.sum { |_, product_info| product_info[:total] }

puts "Ваша корзина покупок: #{shopping_cart}"
puts "Итоговая сумма покупок: #{total}"
