package shared

inline fun < reified T> List<T>.removeAt(i: Int) = filterIndexed { index, _ -> index != i }