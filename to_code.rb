result = []
consecutive_zeros = 0

File.open("a.out", "rb") do |file|
  while char = file.read(1)
    byte = char.unpack("C").first

    if byte == 0
      consecutive_zeros += 1
    end

    if consecutive_zeros > 500
      break
    else
      result << "0x#{"%02x" % [byte]}"
    end
  end
end

formatted = result
  .each_slice(8)
  .map { |group| group.join(", ") }
  .join(",\n")

File.write("a.c", formatted)