library(shiny)
library(ggplot2)

ui <- fluidPage(
  fileInput(inputId = "upload_file", label = "File:"),
  plotOutput(outputId = "view_plot"),
  actionButton(inputId = "refresh", label = "View last plot")
)

server <- function(input, output, session) {
  myPlot <- reactiveVal()
  
  observeEvent(input$upload_file, ignoreInit = TRUE, {
    if (!is.null(input$upload_file)) {
      filepath <- input$upload_file$datapath
      if (file.exists(filepath)) {
        dataframe <- read.csv(file = filepath)
        myPlot(ggplot(dataframe, aes(x = x, y = y)) + geom_line())
      }
    }
  })
  
  output$view_plot <- renderPlot({ print(myPlot()) })
  
  observeEvent(input$refresh, ignoreInit = TRUE, {
    if (!is.null(ggplot2::last_plot())) {
      myPlot(ggplot2::last_plot())
    }
  })
}

shinyApp(ui = ui, server = server)
