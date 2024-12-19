package de.sam.aoc.days

import java.io.File

fun main() {
    fun isPlausible(towelOptions: List<String>, towel: String): Boolean =
        towel.isEmpty() || towelOptions.any {
            towel.startsWith(it) && isPlausible(towelOptions, towel.removePrefix(it))
        }

    fun countPlausibleMemoized(
        towelOptions: List<String>,
        towel: String,
        memo: MutableMap<String, Long> = mutableMapOf()
    ): Long = memo.getOrPut(towel) {
        if (towel.isEmpty()) 1L
        else towelOptions
            .filter { towel.startsWith(it) }
            .sumOf { countPlausibleMemoized(towelOptions, towel.removePrefix(it), memo) }
    }

    val (towelOptions, requestedTowels) =
        File("input.txt")
            .readLines()
            .let { it.first().split(", ") to it.drop(2) }

    requestedTowels
        .count { isPlausible(towelOptions, it)  }
        .also { println("Plausible combinations: $it") }

    requestedTowels
        .sumOf { countPlausibleMemoized(towelOptions, it) }
        .also { println("Plausible combinations: $it") }
}