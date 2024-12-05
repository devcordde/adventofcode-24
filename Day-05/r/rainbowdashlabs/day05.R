lines <- readLines("input.txt")

split <- match("", lines)
rules <- lines[seq_len(split - 1)]
updates <- lines[-seq_len((split))]

rules <- lapply(rules, function(x) {
  split <- strsplit(x, "\\|")
  return(unlist(lapply(split, as.numeric)))
})

get_rules <- function(x) {
  matches <- Filter(function(rule) {
    return(rule[1] == x)
  }, rules)
  return(sapply(matches, function(x) { x[2] }))
}

updates <- lapply(updates, function(x) {
  split <- strsplit(x, ",")
  return(unlist(lapply(split, as.numeric)))
})

order_update <- function(update) {
  seq <- update
  while (TRUE) {
    broke <- FALSE
    for (i in seq_along(seq)) {
      # Get numbers that are supposed to be after the current number
      numbers_after <- get_rules(seq[i])
      # Get the numbers that are currently before our number
      before <- seq[seq_len(i)]
      for (x in seq_along(before)) {
        # Check whether any number before our current number is not supposed to be there.
        if (before[x] %in% numbers_after) {
          #print(sprintf("%s at %s is supposed to be behind %s at %s", before[x], x, seq[i], i))
          #print(seq)
          # if so move it behind the current number and repeat.
          up <- append(seq, before[x])
          #print(up)
          #print(sprintf("Removing element at %s", x))
          up <- up[-x]
          #print(up)
          seq <- up
          broke <- TRUE
          break
        }
      }
      if (broke){
        break
      }
    }
    if (broke){
      next
    }
    #print("Nothing to fix")
    #print(seq)
    return(seq)
  }
}

check_order <- function(update) {
  for (i in seq_along(update)) {
    # Get numbers that are supposed to be after the current number
    numbers_after <- get_rules(update[i])
    # Get the numbers that are currently before our number
    before <- update[seq_len(i)]
    for (x in seq_along(before)) {
      # Check whether any number before our current number is not supposed to be there.
      if (before[x] %in% numbers_after) {
        return(FALSE)
      }
    }
  }
  return(TRUE)
}

correct <- Filter(check_order, updates)
middle <- sapply(correct, function(x) {
  x[length(x) / 2 + 1]
})

sprintf("Part 1: %s", sum(middle))

incorrect <- Filter(function(x) {
  return(!check_order(x))
}, updates)
corrected <- sapply(incorrect, order_update)
middle <- sapply(corrected, function(x) {
  x[length(x) / 2 + 1]
})

sprintf("Part 2: %s", sum(middle))
