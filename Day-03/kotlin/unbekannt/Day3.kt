import java.io.File

fun main(){
    partOneDay3()
    partTwoDay3()
}

fun partOneDay3(){
    java.io.File("Aoc-Day3.txt").readLines()
        .sumOf {
            "mul\\((\\d{1,3}),(\\d{1,3})\\)".toRegex().findAll(it).map { it.groupValues[1].toInt() * it.groupValues[2].toInt() }.sum()
        }
        .let { println(it) }
}

fun partTwoDay3(){
    java.io.File("Aoc-Day3.txt").readLines().joinToString("").let {
        val does = "do\\(\\)".toRegex().findAll(it).toList()
        val mul = "mul\\((\\d{1,3}),(\\d{1,3})\\)".toRegex().findAll(it).toList()
        val dont = "don't\\(\\)".toRegex().findAll(it).toList()
        var sum = 0;
        var isDO = true
        var doCounter = 0
        var dontCounter = 0
        mul.forEach {
            var currentMul = it.range
            val nearestdo = does.filter { it.range.last < currentMul.first }.maxByOrNull { it.range.last }
            val nearestdont = dont.filter { it.range.last < currentMul.first }.maxByOrNull { it.range.last }

            isDO = if(nearestdo == null && nearestdont == null){
                true
            } else if(nearestdont != null && nearestdo == null){
                false
            } else if(nearestdont == null){
                true
            } else if(nearestdont.range.last < nearestdo!!.range.first){
                true
            } else {
                false
            }
            if (isDO)
                sum += it.groupValues[1].toInt() * it.groupValues[2].toInt()
        }
        sum
    }.let { println(it) }
}