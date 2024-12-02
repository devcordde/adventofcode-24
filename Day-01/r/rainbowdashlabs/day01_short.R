lines <- readLines("input.txt")

parts <- lapply(lines, function(x) strsplit(x, "[[:space:]]+")[[1]])
nums <- do.call("rbind", lapply(parts, as.numeric))
left <- sort(nums[, 1])
right <- sort(nums[, 2])

sprintf("Part 1: %d", sum(abs(left - right)))

sprintf("Part 2: %d", sum(left * sapply(left, function(num) sum(right == num))))
