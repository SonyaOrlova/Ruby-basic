TILL = 100

fibonacci = [1, 1]

loop do
  number = fibonacci.last(2).sum

  break if number > TILL

  fibonacci << number
end
