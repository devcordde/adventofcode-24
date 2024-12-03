import java.io.File
import java.lang.ProcessBuilder.Redirect.to

fun main(){
    partOne()
    partTwo()
}

fun partTwo(){
    java.io.File("input.txt").readLines()
        .map { it.split("   ") }
        .map { it.first().toInt() to it.last().toInt() }
        .unzip()
        .let { (first, second) -> first to second }
        .let { (first, second) -> first to second.groupingBy { it }.eachCount() }
        .let { (first, second) -> first.map {
            val secondValue = second[it] ?: 0;
            it*secondValue
        }
        }.sum().let { println("Part Two: $it") }
}

fun partOne(){
    var result = java.io.File("input.txt").readLines().map { string -> string.split("   ") }
        .map { strings -> strings.first().toInt() to strings.last().toInt() }
        .unzip()
        .let { (listOne, listTwo) -> listOne.sortedDescending() to listTwo.sortedDescending() }
        .let { (listOne, listTwo) -> listOne.zip(listTwo).map { pair -> pair.first - pair.second } }
        .sumOf { i -> if (i < 0) i * -1 else i }

    println("Part One: $result")
}