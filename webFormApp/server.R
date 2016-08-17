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
    })

    observeEvent(input$submit_another, {
                 shinyjs::show("form")
                 shinyjs::hide("submit_msg")
    })

    output$tablePanelContainer <- renderUI({
        div(id = "tablePanel",
            a(id = "toggleTable",
              "Show/Hide",
              class = "left-space"),
            div(id = "tableOutput",
                DT::dataTableOutput("responsesTable"),
                downloadButton("downloadBtn", "Download entries")
            )
        )
    })
    
    shinyjs::onclick("toggleTable", 
                     shinyjs::toggle(id = "tableOutput", anim = TRUE))

    output$responsesTable <- DT::renderDataTable(
        loadData(),
        rownames = FALSE,
        options = list(searching = FALSE, lengthChange = FALSE)
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
