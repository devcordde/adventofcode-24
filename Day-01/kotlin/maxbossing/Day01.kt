import kotlin.math.abs

class Day01(private val input: List<String>) {

    private val list1 = mutableListOf<Int>()
    private val list2 = mutableListOf<Int>()

    init {
        input.map {
            it.split("   ")
                .let { s ->
                    s[0].toInt() to s[1].toInt()
                }
        }.forEach {
            list1.add(it.first)
            list2.add(it.second)
        }
    }

    val pairs = list1.sorted().zip(list2.sorted())

    fun part1(): Int = pairs.sumOf { abs(it.first - it.second) }
    fun part2(): Int = list1.sumOf { it * list2.count { p -> p == it } }
}