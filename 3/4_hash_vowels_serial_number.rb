VOWELS_REGEXP = /[aeoui]/

alphabet = ('a'..'z').to_a

vowels_serial_number = alphabet.filter_map.with_index(1) { |letter, i| [letter, i] if letter =~ VOWELS_REGEXP }.to_h
