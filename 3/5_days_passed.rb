days_per_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

print "Введите дату в формате ДД.MM.ГГГГ: "

day, month, year = gets.chomp.split('.').map(&:to_i)

is_leap_year = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

days_per_months[1] = 29 if is_leap_year

days_passed = days_per_months.first(month - 1).sum + day
