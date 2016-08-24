library(shiny)
source("globals.R")
source("helpers.R")

function(input, output, session) {
    observe({
        # check if all mandatory fields have a value
        mandatoryFilled <-
            vapply(fieldsMandatory,
                   function(x) {
                       !is.null(input[[x]]) && input[[x]] != ""
                   },
                   logical(1))
        mandatoryFilled <- all(mandatoryFilled)

        # enable/disable the submit button
        shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
    })

    formData <- reactive({
        data <- sapply(fieldsAll, 
                       function(x) {
                           if (length(input[[x]]) > 1) {
                               paste(input[[x]], collapse = ", ")
                           } else {
                               input[[x]]
                           }
                       })
        data <- c(data, timestamp = epochTime())
        data
    })
    
    observeEvent(input$new, {
                 shinyjs::reset("id")
                 shinyjs::reset("form")
    })
    # action to take when submit button is pressed
    observeEvent(input$submit, {
            shinyjs::disable("submit")
            shinyjs::show("progress_msg")
            shinyjs::hide("error")

            tryCatch({
                 saveData(formData())
                 shinyjs::reset("form")
                 shinyjs::hide("form")
                 shinyjs::show("submit_msg")
            },
            error = function(err) {
                shinyjs::html("error_msg", err$message)
                shinyjs::show(id = "error", anim = TRUE, animType = "fade")
            },
            finally = {
                shinyjs::enable("submit")
                shinyjs::hide("progress_msg")
            })
    }, priority = 1)

    observeEvent(input$submit_another, {
                 shinyjs::show("form")
                 shinyjs::hide("submit_msg")
    })

    observeEvent(input$responsesTable_rows_selected, {
        row_num <- input$responsesTable_rows_selected
        if (length(row_num) > 0) {
            data <- loadData()[row_num, ]
            updateInputs(data, session)
        }
    })

    observeEvent(input$update, {
        row_num <- input$responsesTable_rows_selected
        
        if (row_num > 0 && !is.null(row_num)) {
            shinyjs::disable("update")
            tryCatch({
                deleteData(row_num)
                saveData(formData())
                shinyjs::reset("form")
            },
            error = function(err) {
                shinyjs::html("error_msg", err$message)
                shinyjs::show(id = "error", anim = TRUE, animType = "fade")
            },
            finally = {
                shinyjs::enable("update")
            })       
        }
    }, priority = 1)
    
    observeEvent(input$delete, {
        row_num <- input$responsesTable_rows_selected
        
        if (row_num > 0 && !is.null(row_num)) {
            shinyjs::disable("delete")
            tryCatch({
                deleteData(row_num)
                shinyjs::reset("id")
                shinyjs::reset("form")
            },
            error = function(err) {
                shinyjs::html("error_msg", err$message)
                shinyjs::show(id = "error", anim = TRUE, animType = "fade")
            },
            finally = {
                shinyjs::enable("delete")
            })
        }   
    }, priority = 1)

    output$tablePanelContainer <- renderUI({
        div(id = "tablePanel",
            a(id = "toggleTable",
              "Show/Hide",
              class = "left-space"),
            div(id = "tableOutput",
                DT::dataTableOutput("responsesTable"),
                downloadButton("downloadBtn", "Download entries"),
                hr(),
                shinyjs::disabled(textInput("id", "ID Selected", width = "20%")),
                actionButton("new", "New"),
                actionButton("update", "Update"),
                actionButton("delete", "Delete")
            )
        )
    })
    
    shinyjs::onclick("toggleTable", 
                     shinyjs::toggle(id = "tableOutput", anim = TRUE))
    
    output$responsesTable <- DT::renderDataTable({
        input$submit
        input$update
        input$delete
        loadData()
    },  selection = "single",
        rownames = FALSE,
        options = list(lengthChange = FALSE)
    )

    output$downloadBtn <- downloadHandler(
        filename <- function() {
            sprintf("eval-cancer-driver-prediction-methods_%s.csv", humanTime())
        },
        content <- function(file) {
            write.csv(loadData(), file, row.names = FALSE)
        }
    )
}
