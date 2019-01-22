input <- file("stdin", "r")
is_first_line <- TRUE

while(length(line <- readLines(input, n=1, warn=FALSE)) > 0) {
  line <- unlist(strsplit(line, "\t"))
  # current line belongs to previous
  if(!is_first_line &&
     prev_lang == line[1] &&
     prev_2gram == line[2]) {
    sum <- sum + as.integer(line[3])
  }
  # current line belongs either to a
  # new key pair or is first line
  else {
    # new key pair - so output the last
    # key pair's result
    if(!is_first_line) {
      # language / 2-gram / count
      cat(prev_lang,"\t",prev_2gram,"\t",sum,"\n")
    }
    # initialize state trackers
    prev_lang <- line[1]
    prev_2gram <- line[2]
    sum <- as.integer(line[3])
    is_first_line <- FALSE
  }
}

# the final record
cat(prev_lang,"\t",prev_2gram, "\t", sum, "\n")

close(input)