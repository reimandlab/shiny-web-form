source("globals.R")

epochTime <- function() {
    as.integer(Sys.time())
}

humanTime <- function() {
    format(Sys.time(), "%Y%m%d-%H%M%OS")
}

saveData <- function(data) {
    if (!dir.exists(responseDir)) dir.create(responseDir)

    fileName <- sprintf("%s_%s.csv",
                        humanTime(),
                        digest::digest(data))
    write.csv2(x = t(data), file = file.path(responseDir, fileName), quote = TRUE)
}

loadData <- function() {
    files <- list.files(file.path(responseDir),
                        full.names = TRUE)
    data <- lapply(files, read.csv2, stringsAsFactors = FALSE)
    data <- do.call(rbind, data)
    if (is.data.frame(data)) {
        colnames(data)[1] <- "ID"
        data$ID <- seq.int(nrow(data))
    }
    data
}
