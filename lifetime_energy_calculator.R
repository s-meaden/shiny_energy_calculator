
library(shiny)

ui <- fluidPage(
  titlePanel("Appliance Lifetime Cost Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("product", "Product Type", "Fridge"),
      textInput("make", "Make", "Fridgemaster"),
      textInput("model", "Model Number", "MC55265DES"),
      numericInput("energy", "Annual Energy Consumption (kWh)", 210, min = 0),
      numericInput("cost_kwh", "Electricity Price (per kWh, £)", 0.1857, min = 0, step = 0.001),
      numericInput("lifespan", "Expected Lifespan (years)", 10, min = 1),
      numericInput("item_cost", "Cost of Item incl. service (£)", 299, min = 0)
    ),
    
    mainPanel(
      h3("Results"),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  output$results <- renderTable({
    # Annual cost
    annual_cost <- input$energy * input$cost_kwh
    
    # Lifetime energy cost
    lifetime_energy <- annual_cost * input$lifespan
    
    # Total lifetime cost
    lifetime_total <- lifetime_energy + input$item_cost
    
    data.frame(
      `Product Type` = input$product,
      `Make` = input$make,
      `Model Number` = input$model,
      `Annual Energy Consumption (kWh)` = input$energy,
      `Annual Electricity Cost (£)` = round(annual_cost, 2),
      `Expected Lifespan (Years)` = input$lifespan,
      `Lifetime Energy Cost (£)` = round(lifetime_energy, 2),
      `Cost of Item (£)` = input$item_cost,
      `Lifetime Cost (£)` = round(lifetime_total, 2)
    )
  })
}

shinyApp(ui, server)
