class Day03(val input: String) {
    private fun parseMultiplication(str: String): Int =
        str.trim { !it.isDigit() && it != ',' }
            .split(",")
            .map { it.toInt() }
            .fold(1) { acc, num -> acc * num}

    private val mulRegex = Regex("""mul\([0-9]+,[0-9]+\)""".trimIndent())
    private val instructionRegex = Regex("""(mul\([0-9]+,[0-9]+\)|do[n't]*\(\))""")

    fun part1(): Int =
        mulRegex.findAll(input).sumOf { parseMultiplication(it.value) }

    fun part2(): Int {
        var enabled = true
        return instructionRegex.findAll(input).sumOf {
            when {
                it.value.startsWith("mul") -> if (enabled) parseMultiplication(it.value) else 0
                it.value == "don't()" -> { enabled = false; 0}
                it.value == "do()" -> { enabled = true; 0 }
                else -> 0
            }
        }
    }
}