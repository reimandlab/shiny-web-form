library(shiny)
source("globals.R")

fluidPage(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(appCSS),
    titlePanel("Evaluation of Cancer Driver Prediction Methods"),

    fluidRow(
        column(6,
        div(id = "form",
            h3("General"),
            textInput("method_name", labelMandatory("Name of method")),
            numericInput("year_published", labelMandatory("Year of publication"), 2016, 1900, 2016),
            textInput("title", labelMandatory("Title of publication")),
            textInput("journal", labelMandatory("Journal")),
            textInput("authors", labelMandatory("Authors")),
            textInput("pubmedID", labelMandatory("PubMed ID")),
            radioButtons("scope", "Does the method/publication fit our scope",
                         c("Yes", "Maybe", "No")),
            hr(),
            h3("Input Data"),
            checkboxGroupInput("type_of_genome_seq_data", "What type of genome sequencing data are used",
                         c("WES", "WGS", "Gene panels", "Other (please describe)" = "Other")),
            conditionalPanel("~input.type_of_genome_seq_data.indexOf('Other')", 
                             textInput("type_of_genome_seq_data_description", "Describe")),
            checkboxGroupInput("driver_gene_ID_strategy", "What is the primary strategy of identifying driver genes",
                         c("Recurrence (higher than expected number of mutations in region" ,
                           "Functional impact (mutations affect important sites, e.g. conserved sites)",
                           "Combined", "Other (please describe)" = "Other")),
            conditionalPanel("~input.driver_gene_ID_strategy.indexOf('Other')", 
                             textInput("driver_gene_ID_strategy_description", "Describe")),
            checkboxGroupInput("cancer_type_tested", "What types of cancer tested", 
                         c("Single cancer type", "Multiple cancer types", "Pan-Cancer analysis")),
            checkboxGroupInput("method_account_for_cofactors", "Does the method account for cofactors", 
                         c("Sequence trinucleotide content", "Gene expression level", 
                           "Protein disorder", "Gene replication", "Other (please describe)" = "Other",
                           "None")),
            conditionalPanel("~input.method_account_for_cofactors.indexOf('Other')", 
                             textInput("method_account_for_cofactors_description", "Describe")),
            radioButtons("limited_to_subset_of_genes", paste("Is the method limited to a subset of genes ",
                                                              "(e.g ncRNAs, genes with phosphosites, genes ",
                                                              "with 3D protein structures, etc)", sep = ""),
                         c("Yes (please describe)" = "Yes", "No")),
            conditionalPanel("input.limited_to_subset_of_genes == 'Yes'", 
                             textInput("subset_description", "Describe")),
            hr(),
            h3("Statistical Significance Testing"),
            checkboxGroupInput("method_compute_pvals", "Does the method compute p-values",
                         c("Standartd test (T, Fisher's Exact, Wilcoxon, etc)",
                           "Model-based test (e.g. linear regression)",
                           "Sample-based test (permutation test, bootstrap", "No p-values computed")),
            radioButtons("supervised_learning", paste("Does method perform supervised learning using known ",
                                                      "examples (support vector machine, naive bayes, ",
                                                      "random forests, etc)", sep = ""),
                         c("Yes (please describe)" = "Yes", "No")),
            conditionalPanel("input.supervised_learning == 'Yes'", 
                             textInput("supervised_learning_description", "Describe")),
            hr(),
            h3("Method Evaluation"),
            checkboxGroupInput('enrichment_of_known_cancer_genes', paste("Enrichment of known cancer genes ",
                                                                         "among results (check one or more)", sep = ""),
                               c("Based on sequencing studies", "Based on complementary omics studies",
                                 "Based on earlier literature", "None")),
            radioButtons("pathway_network_analysis", 
                         "Pathway & network analysis of resulting genes", c("Yes", "No")),
            radioButtons("literature_analysis", "Literature analysis of resulting genes", c("Yes", "No")),
            radioButtons("performance_on_rand_input_data_to_eval_FDR", 
                         paste("Performance on randomised input data to ",
                               "evaluate false discovery rate", sep = ""), c("Yes", "No")),
            radioButtons("performance_on_rand_subset_of_data_test_robustness", 
                         paste("Perfomance on random subsets of data ",
                               "to test robustness", sep = ""), c("Yes", "No")),
            radioButtons("performance_rel_to_other_methods", 
                         paste("Performance relative to other cancer ",
                               "driver discovery methods", sep = ""), c("Yes", "No")),
            radioButtons("eval_of_method_params", "Evaluation of method parameters", c("Yes", "No")),
            radioButtons("eval_of_resulting_pval_distributions", 
                         paste("Evaluation of resulting p-value distributions ",
                               "(quantile-quantile analysis, etc)", sep = ""), c("Yes", "No")),
            actionButton("submit", "Submit", class = "btn-primary"),
            shinyjs::hidden(
                span(id = "progress_msg", "Submitting..."),
                div(id = "error", 
                    div(br(), tags$b("Error: "), span(id = "error_msg"))
                )
            )
        ),

            shinyjs::hidden(
                div(
                    id="submit_msg",
                    h3("This entry was submitted successfully!"),
                    actionLink("submit_another", "Submit another response")
                )
            )
        ),
        column(6,
           uiOutput("tablePanelContainer")
        )
    )   
)
