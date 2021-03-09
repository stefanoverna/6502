consecutive_zeros = 0

File.open('b.out', 'wb') do |out|
  File.open('a.out', 'rb') do |file|
    while (char = file.read(1))
      byte = char.unpack1('C')

      consecutive_zeros += 1 if byte.zero?

      break if consecutive_zeros > 50

      out.write(char)
    end
  end
end
