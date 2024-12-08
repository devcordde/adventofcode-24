package shared

inline fun <reified T: Enum<T>> enumCombinationSequence(
    enumValues: Array<T>,
    length: Int
): Sequence<Array<T>> {
    return sequence {
        val indices = IntArray(length) { 0 }
        val maxIndex = enumValues.size - 1

        while (true) {
            yield(indices.map { enumValues[it] }.toTypedArray())

            var position = length - 1
            while (position >= 0) {
                if (indices[position] < maxIndex) {
                    indices[position]++
                    break
                } else {
                    indices[position] = 0
                    position--
                }
            }

            if (position < 0) break
        }
    }
}