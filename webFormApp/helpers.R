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

updateRadioBtns <- function(field, data, session) {
    if (is.null(data[, field])) {
        updateRadioButtons(session, field, selected = "None Selected")
    } else {
        updateRadioButtons(session, field, selected = data[, field])
    }
}

updateCheckbox <- function(field, data, session) {
    if (is.null(data[, field])) {
        updateCheckboxGroupInput(session, field, selected = NULL)
    } else {
        updateCheckboxGroupInput(session, field, 
                                 selected = unlist(strsplit(data[, field] , ", ")))
    }
}

updateInputs <- function(data, session) {
    updateTextInput(session, "id", value = data[,"ID"])
    updateTextInput(session, "method_name", value = data[, "method_name"])
    updateNumericInput(session, "year_published", value = data[, "year_published"])
    updateTextInput(session, "title", value = data[, "title"])
    updateTextInput(session, "journal", value = data[, "journal"])
    updateTextInput(session, "authors", value = data[, "authors"])
    updateTextInput(session, "pubmedID", value = data[, "pubmedID"])
    updateRadioBtns("scope", data, session)
    updateCheckbox("type_of_genome_seq_data", data, session)
    updateTextInput(session, "type_of_genome_seq_data_description", 
                    value = data[, "type_of_genome_seq_data_description"])
    updateCheckbox("driver_gene_ID_strategy", data, session)
    updateTextInput(session, "driver_gene_ID_strategy_description",
                    value = data[, "driver_gene_ID_strategy_description"])
    updateCheckbox("cancer_type_tested", data, session)
    updateCheckbox("method_account_for_cofactors", data, session)
    updateTextInput(session, "method_account_for_cofactors_description",
                    value = data[, "method_account_for_cofactors_description"])
    updateRadioBtns("limited_to_subset_of_genes", data, session)
    updateTextInput(session, "subset_description", value = data[, "subset_description"])
    updateCheckbox("method_compute_pvals", data, session)
    updateRadioBtns("supervised_learning", data, session)
    updateTextInput(session, "supervised_learning_description",
                    value = data[, "supervised_learning_description"])
    updateCheckbox("enrichment_of_known_cancer_genes", data, session)
    updateRadioBtns("pathway_network_analysis", data, session)
    updateRadioBtns("literature_analysis", data, session)
    updateRadioBtns("performance_on_rand_input_data_to_eval_FDR", data, session)
    updateRadioBtns("performance_on_rand_subset_of_data_test_robustness", data, session)
    updateRadioBtns("performance_rel_to_other_methods", data, session)
    updateRadioBtns("eval_of_method_params", data, session)
    updateRadioBtns("eval_of_resulting_pval_distributions", data, session)
    updateRadioBtns("software_available", data, session)
    updateRadioBtns("source_code_available", data, session)
    updateRadioBtns("datasets_available", data, session)
}

deleteData <- function(row_num) {
    data <- loadData()[row_num, ]
    files <- list.files(file.path(responseDir),
                        full.names = TRUE )
    if (file.exists(files[row_num])) {
        comp <- read.csv2(files[row_num], stringsAsFactors = FALSE)
        if (identical(data[, "timestamp"], comp[, "timestamp"]))
            file.remove(files[row_num])
    }
}
