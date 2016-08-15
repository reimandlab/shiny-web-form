fieldsMandatory <- c("method_name", "year_published", "title", "journal",
                     "authors", "pubmedID", "scope")

labelMandatory <- function(label) {
    tagList(
            label,
            span("*", class = "mandatory_star")
            )
}

appCSS <- ".mandatory_star { color: red; }"

fieldsAll <- c("method_name", "year_published", "title", "journal", "authors",
               "pubmedID", "scope", "seq_data", "IDstrategy", "cancer_type",
               "cofactors", "limit", "limDesc", "method_pvals", "supLearning",
               "supLearningDesc", "enrichment", "pnAnalysis", "litAnalysis", 
               "evalFDR", "evalRobustness", "relPerfomance", "evalParam", 
               "evalDistr")

responseDir <- file.path("responses")

epochTime <- function() {
    as.integer(Sys.time())
}
