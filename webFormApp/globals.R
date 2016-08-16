fieldsMandatory <- c("method_name", "year_published", "title", "journal",
                     "authors", "pubmedID", "scope")

labelMandatory <- function(label) {
    tagList(
            label,
            span("*", class = "mandatory_star")
            )
}

appCSS <- ".mandatory_star { color: red; }
           #error { color : red; }"

fieldsAll <- c("method_name", "year_published", "title", "journal", "authors",
               "pubmedID", "scope", "type_of_genome_seq_data", 
               "driver_gene_ID_strategy", "cancer_type_tested",
               "method_account_for_cofactors", "limited_to_subset_of_genes", 
               "subset_description", "method_compute_pvals", 
               "supervised_learning", "enrichment_of_known_cancer_genes", 
               "pathway_network_analysis", "literature_analysis", 
               "performance_on_rand_input_data_to_eval_FDR", 
               "performance_on_rand_subset_of_data_test_robustness", 
               "performance_rel_to_other_methods", "eval_of_method_params", 
               "eval_of_resulting_pval_distributions")

responseDir <- file.path("responses")

