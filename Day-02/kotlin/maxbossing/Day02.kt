import kotlin.math.abs
import shared.removeAt
import java.nio.file.Path

class Day02 {
    private val input = Path("day02.txt").readText().lines()
    private val rows = input.map { it.split(" ").map { it.toInt() } }

    fun part1() = rows.count {
        it.windowed(2).map { (current, next) ->
            abs(current - next) in 1..3 && current < next
        }.all { it } ||  it.windowed(2).map { (current, next) ->
            abs(current - next) in 1..3 && current > next
        }.all { it }
    }

    fun part2() = rows.count { l ->
        l.indices.any { i ->
            l.removeAt(i).let { it ->
                it.windowed(2).map { (current, next) ->
                    abs(current - next) in 1..3 && current < next
                }.all { it } ||  it.windowed(2).map { (current, next) ->
                    abs(current - next) in 1..3 && current > next
                }.all { it }
            }
        }
    }
}