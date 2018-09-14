#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Ensemble Clustering Application"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("selectedAlgo", "Algorithmes à regrouper",
                  c("K-MEANS (multiple init.)" = "kmeansMI")
      ),
      sliderInput("maxClusterNumber",
                  "Nombre de cluster maximum",
                  min = 1,
                  max = 50,
                  value = 5),
      radioButtons("dataMode", "Jeu de donnees",
                   c("Generation aleatoire" = "randomGen")
      ),
      actionButton(inputId ="submit_button", label = "Générer")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      splitLayout(
        plotOutput("plotKM1"),
        plotOutput("plotKM2")
      ),
      plotOutput("plotCE")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  observeEvent(
    eventExpr = input[["submit_button"]],
    handlerExpr = {
      system(paste('python test_pyFonc.py ', input$maxClusterNumber))
      
      datas = read.table(file="datas.csv", header=FALSE, sep=",")
      km1 <- read.csv(file="km1.csv", header=FALSE, sep=",")
      km2 <- read.csv(file="km2.csv", header=FALSE, sep=",")
      ce <- read.csv(file="ce.csv", header=FALSE, sep=",") 
      
      datas = round (datas, digits = 2)
      
      km1 = unlist(km1, use.names=FALSE)
      km2 = unlist(km2, use.names=FALSE)
      ce = unlist(ce, use.names=FALSE)
      
      paletteColor <- c('#E41A1C', '#377EB8', '#4DAF4A', '#984EA3',
                        '#FF7F00', '#FFFF33', '#A65628', '#F781BF', '#999999')
      output$plotKM1<- renderPlot({
        palette(paletteColor)
        
        par(mar = c(5.1, 4.1, 0, 1))
        plot(datas,
             col = km1,
             pch = 20, cex = 2)
      })
      
      output$plotKM2 <- renderPlot({
        palette(paletteColor)
        
        par(mar = c(5.1, 4.1, 0, 1))
        plot(datas,
             col = km2,
             pch = 20, cex = 2)
      })
      
      output$plotCE <- renderPlot({
        palette(paletteColor)
        
        par(mar = c(5.1, 4.1, 0, 1))
        plot(datas,
             col = ce,
             pch = 20, cex = 2)
      })
    }
    
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)

