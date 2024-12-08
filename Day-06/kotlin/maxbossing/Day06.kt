
class Day06(var input: List<String>) {

    private val guardChars = charArrayOf('^', 'v', '<', '>')

    fun solveField(field: MutableList<MutableList<Char>>): Int {
        var y = field.indexOfFirst { s -> guardChars.any { s.contains(it) } }
        var x = field[y].indexOfFirst { it in guardChars }
        var steps = 0
        while ((y  in 0..<field.size && x in 0..<field[0].size)) {
            var guard = field[y][x]
            when (guard) {
                '^' -> {
                    if (y == 0) break
                    if (field[y - 1][x] == '#') {
                        guard = '>'
                    } else {
                        y--
                    }
                }

                'v' -> {
                    if (y >= field.size-1) break
                    if (field[y + 1][x] == '#') {
                        guard = '<'
                    }else {
                        y++
                    }
                }

                '>' -> {
                    if (x >= field.size-1) break
                    if (field[y][x + 1] == '#') {
                        guard = 'v'
                    }else {
                        x++
                    }
                }

                '<' -> {
                    if (x == 0) break
                    if (field[y][x - 1] == '#') {
                        guard = '^'
                    } else {
                        x--
                    }
                }
            }
            field[y][x] = guard
            steps++
            if (steps > 10_000) return -1
        }
        return field.sumOf { it.count { it in guardChars } }
    }

    fun part1(): Int = solveField(input.map { it.toMutableList() }.toMutableList())

    fun part2(): Int {
        var loop = 0
        y@for (y in input.indices) {
            x@for (x in input[y].indices) {
                if (input[y][x] == '#' || input[y][x] in guardChars) continue@x
                if (solveField(input.map { it.toMutableList() }.toMutableList().apply { this[y][x] = '#' }) == -1){
                    loop++
                } else {
                }
            }
        }
        return loop
    }
}