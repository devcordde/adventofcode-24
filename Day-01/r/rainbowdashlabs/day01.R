lines <- readLines("input.txt")

left <- NULL
right <- NULL

for (line in lines) {
  parts <- strsplit(line, "[[:space:]]+")
  nums <- unlist(as.numeric(unlist(parts)))
  left <- c(left, nums[1])
  right <- c(right, nums[2])
}

left <- sort(left)
right <- sort(right)

distances <- NULL

for (i in seq_along(left)) {
  distances <- append(distances, abs(left[i] - right[i]))
}

sprintf("Part 1: %d", sum(distances))

right <- unlist(right)

res <- 0

for (num in left) {
  res <- res + num * sum(right == num)
}

sprintf("Part 2: %d", res)
