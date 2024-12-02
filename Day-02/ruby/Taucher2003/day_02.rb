input = ARGF.read.lines.map { |line| line.split(' ').map { |num| Integer(num, exception: true) } }

def safe_levels?(l, r, direction)
  (l - r).negative? == direction.negative? && (1..3).cover?((l - r).abs)
end

def safe?(report, dampener: false)
  safe = true
  direction = report[0] - report[1]
  report.each_cons(2) do |(l, r)|
    safe = false unless safe_levels?(l, r, direction)
  end
  safe || (dampener && dampener_safe?(report))
end

def dampener_safe?(report)
  report.size.times do |iteration|
    dampened_report = report.dup
    dampened_report.delete_at(iteration)
    return true if safe?(dampened_report)
  end
  false
end

puts "Part 1: #{input.count { |report| safe?(report) }}"
puts "Part 2: #{input.count { |report| safe?(report, dampener: true) }}"
