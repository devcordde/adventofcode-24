lines <- readLines("input.txt")
mat <- do.call(rbind, strsplit(lines, ""))

gen_coords <- function(x, y, offset = 3, cross = FALSE) {
  coords <- list(
    # vert ll to ur
    mapply(function(a, b) c(a, b), (y - offset):(y + offset), (x - offset):(x + offset), SIMPLIFY = FALSE),
    # vert ul to lr
    mapply(function(a, b) c(a, b), (y + offset):(y - offset), (x - offset):(x + offset), SIMPLIFY = FALSE)
  )
  if (!cross) {
    coords <- append(coords, list(
      # horizontal
      mapply(function(a, b) c(a, b), y, (x - offset):(x + offset), SIMPLIFY = FALSE),
      # vertical
      mapply(function(a, b) c(a, b), (y + offset):(y - offset), x, SIMPLIFY = FALSE)
    ))
  }
  return(lapply(coords, function(a) {return(Filter(function(b) {return(!(b[1] > nrow(mat) || b[2] > ncol(mat) || any(b < 1)))}, a))}))
}

count_xmas <- function(x, y, match = "XMAS", center = "X", cross = FALSE, offset = 3) {
  if (mat[y, x] != center) return(0)
  xmas <- 0
  coords <- gen_coords(x, y, cross = cross, offset = offset)
  for (coord in coords) {
    if (length(coord) < nchar(match)) next
    pattern <- unlist(mat[matrix(unlist(coord), ncol = 2, byrow = TRUE)])
    if (grepl(match, paste(pattern, collapse = ""), fixed = TRUE)) xmas <- xmas + 1
    if (grepl(match, paste(rev(pattern), collapse = ""), fixed = TRUE)) xmas <- xmas + 1
  }
  return(xmas)
}

matches <- 0
for (y in 1:nrow(mat)) {
  for (x in 1:ncol(mat)) {
    matches <- matches + count_xmas(x, y)
  }
}

sprintf("Part 1: %s", matches)

matches <- 0
for (y in 1:nrow(mat)) {
  for (x in 1:ncol(mat)) {
    res <- count_xmas(x, y, "MAS", "A", TRUE, 1)
    if (res == 2) {
      matches <- matches + 1
    }
  }
}

sprintf("Part 2: %s", matches)
