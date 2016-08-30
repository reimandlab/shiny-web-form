files <- list.files("responses", pattern="*.csv", full.names = TRUE)

for(i in 1:length(files)) {
    df <- read.csv2(files[i])
    df$type <- NA
    df <- df[-1]
    df <- df[c(1:6, 32, 7:31)]
    write.csv2(df, files[i])
    rm(df)
}
