import shared.enumCombinationSequence
import java.nio.file.Path

private typealias Calculation = Pair<Long, List<Long>>

class Day07 {
    private val input = Path("day07.txt").readText().lines()
    private enum class Operation(val reduceAction: (Long, Long) -> Long) {
        PLUS({i, j -> i+j}),
        MUL({i, j -> i*j}),
        CONCAT({i, j -> "$i$j".toLong() })
    }

    private val calculations = input
        .map { string ->
            Calculation(
                string.split(":")[0].toLong(),
                string.split(": ")[1]
                    .split(" ")
                    .map { num -> num .toLong() }
            )
        }

    private fun Calculation.isPossible(allowedOperations: Array<Operation>): Boolean =
        enumCombinationSequence(allowedOperations, second.size-1).any { operations ->
            second.reduceIndexed { index, acc, next ->
                if (index == 0) return@reduceIndexed 0
                operations[index - 1].reduceAction(acc, next)
            } == first
        }

    fun part1() = calculations.filter { it.isPossible(arrayOf(Operation.PLUS, Operation.MUL)) }.map { it.first.toBigInteger() }.sumOf { it }
    fun part2() = calculations.filter { it.isPossible(Operation.entries.toTypedArray()) }.map { it.first.toBigInteger() }.sumOf { it }
}