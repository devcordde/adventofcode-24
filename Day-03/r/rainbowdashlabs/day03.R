lines <- readLines("input.txt")
# I got to the conclusion that joining solves all problems. But now all my code is designed for multi lines, so I will still handle this as multi lines.
lines <- paste(lines, collapse = "")

extract <- function(str) {
  proto <- data.frame(number = integer(), multiplier = integer(), stringsAsFactors = FALSE)
  data <- strcapture("^\\(([0-9]{1,3}),([0-9]{1,3})\\).?", str, proto)
  return(c(data[[1]], data[[2]]))
}

mult_row <- function(row) {
  extracted <- lapply(row, extract)
  filtered <- extracted[!sapply(extracted, function(x) any(is.na(x)))]
  res <- sum(sapply(filtered, function(x) x[1] * x[2]))
  return(res)
}

sum_row <- function (row){
    return(mult_row(unlist(strsplit(row, "mul"))))
}

res <- sum(sapply(lines, sum_row))

sprintf("Part 1: %d", res)

extract_enabled <- function(line) {
  blocks <- unlist(strsplit(line, "do\\(\\)"))
  res <- lapply(blocks, function (block) unlist(strsplit(block,"don't\\(\\)"))[1])
  return(unlist(res))
}

active_blocks <- unlist(lapply(lines, extract_enabled))

res <- sum(sapply(active_blocks, sum_row))
sprintf("Part 2: %d", res)
