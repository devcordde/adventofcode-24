input = ARGF.read.lines.map { |line| line.split('   ').map { |num| Integer(num, exception: true) } }
left, right = [], []

input.each do |(l, r)|
  left << l
  right << r
end

def part1(left, right)
  acc = 0
  left.size.times do
    l_min = left.min
    r_min = right.min
    left.delete_at(left.index(l_min))
    right.delete_at(right.index(r_min))

    acc += (l_min - r_min).abs
  end
  acc
end

def part2(left, right)
  left.each_with_object({value: 0}) do |item, obj|
    obj[:value] += item * right.count { |i| i == item }
  end[:value]
end

puts "Part 1: #{part1(left.dup, right.dup)}"
puts "Part 2: #{part2(left, right)}"
