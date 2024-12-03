input = ARGF.read

def calculate(input, always_enabled: false)
  mul_enabled = true
  match_data = []
  input.scan(/(?:mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))/) do
    match = Regexp.last_match
    mul_enabled = true if match[0] == "do()"
    mul_enabled = false if match[0] == "don't()"

    match_data << [match[1], match[2]] if mul_enabled || always_enabled
  end

  match_data.each { |match| match.map!(&:to_i) }

  match_data.map { |match| match.reduce(:*) }.reduce(:+)
end

puts "Part 1: #{calculate(input, always_enabled: true)}"
puts "Part 2: #{calculate(input)}"
