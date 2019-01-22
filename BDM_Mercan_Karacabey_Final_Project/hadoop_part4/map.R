library(stringdist)

input <- file("stdin", "r")

while(length(line <- readLines(input, n=1, warn=FALSE)) > 0) {
  # in case of empty lines
  if(nchar(line) == 0) break
  
  fields <- unlist(strsplit(line, "\t"))
  
  # extract 2-grams
  d <- qgrams(tolower(fields[4]), q=2)
  
  for(i in 1:ncol(d)) {
    # language / 2-gram / count
    cat(fields[2], "\t", colnames(d)[i], "\t", d[1,i], "\n")
  }
}

close(input)