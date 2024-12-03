lines <- readLines("input.txt")

parts <- lapply(lines, function(x) strsplit(x, "[[:space:]]")[[1]])
nums <- lapply(parts, as.numeric)

check_save <- function(input) {
  diffs <- unlist(diff(input))
  res <- all(diffs >= 1 & diffs <= 3) || all(diffs <= -1 & diffs >= -3)
  sprintf("%s -> %s", toString(diffs), ifelse(res, "TRUE", "FALSE"))
  return(res)
}

res <- lapply(nums, check_save)
print(unlist(res))
sprintf("Part 1: %s", sum(unlist(res)))

check_save_dampened <- function(input) {
  if (check_save(input)) {
    return(TRUE)
  }
  return(any(sapply(1:length(input), function (i) check_save(input[-i]))))
}

res <- lapply(nums, check_save_dampened)

sprintf("Part 2: %s", sum(unlist(res)))
