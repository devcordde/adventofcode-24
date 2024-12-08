package shared

inline fun <reified T> List<List<T>>.transpose(): List<List<T>> = List(this[0].size) { i -> List(this.size) { j -> this[j][i] } }

inline fun <reified T> List<List<T>>.diagonalTranspose(): List<List<T>> {
    val rows = this.size
    val cols = this.first().size

    return (0 until cols).map { col ->
        generateSequence(0 to col) { (i, j) -> (i + 1) to (j - 1) }
            .takeWhile { (i, j) -> i < rows && j >= 0 }
            .map { (i, j) -> this[i][j] }
            .toList()
    } + (1 until rows).map { row ->
        generateSequence(row to cols - 1) { (i, j) -> (i + 1) to (j - 1) }
            .takeWhile { (i, j) -> i < rows && j >= 0 }
            .map { (i, j) -> this[i][j] }
            .toList()
    }
}

inline fun <reified T> List<List<T>>.antiDiagonalTranspose(): List<List<T>> {
    val rows = this.size
    val cols = this.first().size

    return (cols - 1 downTo 0).map { col ->
        generateSequence(0 to col) { (i, j) -> (i + 1) to (j + 1) }
            .takeWhile { (i, j) -> i < rows && j < cols }
            .map { (i, j) -> this[i][j] }
            .toList()
    } + (1 until rows).map { row ->
        generateSequence(row to 0) { (i, j) -> (i + 1) to (j + 1) }
            .takeWhile { (i, j) -> i < rows && j < cols }
            .map { (i, j) -> this[i][j] }
            .toList()
    }
}