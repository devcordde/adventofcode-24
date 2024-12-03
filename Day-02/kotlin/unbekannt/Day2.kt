import java.io.File

fun main() {
    val setup = java.io.File("input.txt").readLines()
        .map { it.split(" ") }
        .map { it.map { it.toInt() } }
    setup.partOne()
        .count { it }.let { println(it) }

    setup.partTwo().count { it }.let { println(it) }
}

private fun Iterable<List<Int>>.partTwo(): List<Boolean> {
    return this.map { row ->
        fun isValid(skipedItem: Int): Boolean {
            var initalRun = true
            var initalSet = false
            var isDesc = false
            var previosNumber = 0
            var valid = true

            row.forEachIndexed { index, it ->
                if(index == skipedItem)
                    return@forEachIndexed
                if (!valid)
                    return@forEachIndexed

                if (!initalSet) {
                    previosNumber = it
                    initalSet = true
                    return@forEachIndexed
                }

                if (it > previosNumber) {
                    if (initalRun) {
                        initalRun = false
                    }
                    if (isDesc)
                        valid = false
                } else {
                    if (initalRun) {
                        initalRun = false
                        isDesc = true
                    }
                    if (!isDesc)
                        valid = false
                }

                var diff = it - previosNumber
                if (diff < 1)
                    diff *= -1

                if (diff !in 1..3)
                    valid = false


                previosNumber = it
            }
            return valid
        }

        var valid = false
        var i = 0

        do {
            valid = isValid(i)
            i++
        }while (!valid && i <= row.size)

        valid
    }
}

private fun Iterable<List<Int>>.partOne() : List<Boolean> {
    return this.map { row ->
        var initalRun = true
        var initalSet = false
        var isDesc = false
        var previosNumber = 0
        var valid = true
        row.forEach {
            if (!valid)
                return@forEach

            if (!initalSet) {
                previosNumber = it
                initalSet = true
                return@forEach
            }

            if (it > previosNumber) {
                if (initalRun) {
                    initalRun = false
                }
                if (isDesc)
                    valid = false
            } else {
                if (initalRun) {
                    initalRun = false
                    isDesc = true
                }
                if (!isDesc)
                    valid = false
            }

            var diff = it - previosNumber
            if (diff < 1)
                diff *= -1

            if (diff !in 1..3)
                valid = false

            previosNumber = it
        }
        valid
    }
}