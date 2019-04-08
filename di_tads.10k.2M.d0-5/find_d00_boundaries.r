b = read.delim("boundaries/combined_boundary.uniq.txt",header=T)
b$name = paste0(b$chr1,":",b$x1)
b$D00 = grepl("D00",b$samples)
b$D02 = grepl("D02",b$samples)
b$D05 = grepl("D05",b$samples)

