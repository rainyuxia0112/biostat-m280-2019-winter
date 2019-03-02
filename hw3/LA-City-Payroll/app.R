library(shiny)
library(shinythemes)
library(shinydashboard)
library(readr)
library(plotly)
library(tidyverse)
library(reshape2)
library(gridExtra)

# Load Data
df_year <- readRDS("TotalPayroll.RDS")
df_employee <- readRDS("EmployeePayroll.RDS")
df_department <- readRDS("DepartmentPayroll.RDS")
df_department_cost <- readRDS("DepartmentPayrollCost.RDS")
df_full <- readRDS("EmploymentType.RDS")

# Helper Functions

pie_chart <- function(df_year, yr) {
  year_payment <-df_year %>%
    filter(Year==yr) %>%
    select(`Year`, `Base Pay`, `Overtime Pay`, `Other Pay`)
  pie_df <- melt(year_payment, id.vars="Year")
  colnames(pie_df) <- c("Year", "Type of Payment", "Amount")
  plot_ly(pie_df, labels = ~`Type of Payment`, values = ~Amount, textposition = 'inside',
          textinfo = 'percent') %>%
    add_pie(hole=0.5)
}

overall_barplot <- function(df_year) {
  year_payment <-df_year %>%
    select(`Year`, `Base Pay`, `Overtime Pay`, `Other Pay`)
  year_payment$Year <- sapply(year_payment$Year, function(x) toString(x))
  df <- melt(year_payment, id.vars="Year")
  colnames(df) <- c("Year", "Payment", "Dollars")
  ggplotly(ggplot(df, aes(x=Year, y=Dollars, fill=Payment, label=Dollars)) + 
             geom_bar(stat="identity", position="dodge"))
}

employee_barplot <- function(df_employee, yr, n) {
  df_employee <- df_employee %>%
    filter(Year == yr) %>%
    select(Person, Total, `Base Pay`, `Overtime Pay`, `Other Pay`)
  df_employee <- df_employee[1:n,] %>%
    cbind("id"=1:n) %>%
    within(Person <- paste(`id`, `Person`, sep="-")) %>%
    select(Person, Total, `Base Pay`, `Overtime Pay`, `Other Pay`)
  df_employee$Person <- factor(df_employee$Person, as.character(df_employee$Person))
  df_employee <- melt(df_employee, id.vars="Person")
  colnames(df_employee) <- c("Employee", "Payment", "Dollars")
  ggplotly(ggplot(data = df_employee, aes(x=Employee, y=Dollars, fill=Payment)) +
             geom_bar(stat="identity", position="dodge") + coord_flip())
}

density_mean <- function(df_department, year, n){
  df <- df_department %>%
    filter(Year == year) %>%
    slice(1:n)
  par(mfrow=c(2,2))
  p1 <- ggplot(df, aes(x=Total)) + 
    geom_density() + geom_vline(aes(xintercept=mean(Total)),
                                color="blue", linetype="dashed", size=1) +
    annotate("text", x=mean(df$Total), y=0,label= toString(mean(df$Total)))
  p2 <- ggplot(df, aes(x=`Base Pay`)) + 
    geom_density() + geom_vline(aes(xintercept=mean(`Base Pay`)),
                                color="blue", linetype="dashed", size=1) +
    annotate("text", x=mean(df$`Base Pay`), y=0,label= toString(mean(df$`Base Pay`))) +
    xlab("Base Pay")
  p3 <- ggplot(df, aes(x=`Overtime Pay`)) + 
    geom_density() + geom_vline(aes(xintercept=mean(`Overtime Pay`)),
                                color="blue", linetype="dashed", size=1) +
    annotate("text", x=mean(df$`Overtime Pay`), y=0,label= toString(mean(df$`Overtime Pay`))) +
    xlab("Overtime Pay")
  p4 <- ggplot(df, aes(x=`Other Pay`)) + 
    geom_density() + geom_vline(aes(xintercept=mean(`Other Pay`)),
                                color="blue", linetype="dashed", size=1) +
    annotate("text", x=mean(df$`Other Pay`), y=0,label= toString(mean(df$`Overtime Pay`))) +
    xlab("Other Pay")
  grid.arrange(p1, p2, p3, p4, nrow = 2)
}

density_median <- function(df_department, year, n){
  df <- df_department %>%
    filter(Year == year) %>%
    slice(1:n)
  par(mfrow=c(2,2))
  p1 <- ggplot(df, aes(x=Total)) + 
    geom_density() + geom_vline(aes(xintercept=median(Total)),
                                color="red", linetype="dashed", size=1)+
    annotate("text", x=median(df$Total), y=0,label= toString(median(df$Total)))
  p2 <- ggplot(df, aes(x=`Base Pay`)) + 
    geom_density() + geom_vline(aes(xintercept=median(`Base Pay`)),
                                color="red", linetype="dashed", size=1) +
    annotate("text", x=median(df$`Base Pay`), y=0,label= toString(median(df$`Base Pay`))) +
    xlab("Base Pay")
  p3 <- ggplot(df, aes(x=`Overtime Pay`)) + 
    geom_density() + geom_vline(aes(xintercept=median(`Overtime Pay`)),
                                color="red", linetype="dashed", size=1) +
    annotate("text", x=median(df$`Overtime Pay`), y=0,label= toString(median(df$`Overtime Pay`))) +
    xlab("Overtime Pay")
  p4 <- ggplot(df, aes(x=`Other Pay`)) + 
    geom_density() + geom_vline(aes(xintercept=median(`Other Pay`)),
                                color="red", linetype="dashed", size=1) +
    annotate("text", x=median(df$`Other Pay`), y=0,label= toString(median(df$`Overtime Pay`))) +
    xlab("Other Pay")
  grid.arrange(p1, p2, p3, p4, nrow = 2)
}

plot_department_cost <- function(df_department_cost, year, n) {
  df <- df_department_cost %>%
    filter(Year == year) %>% 
    select(`Department`, `Base Pay`, `Overtime Pay`, `Other Pay`) %>%
    slice(1:n) %>% 
    cbind("Index"=1:n) %>% 
    within(Department <- paste(`Index`, `Department`, sep="-")) %>%
    select(Department, `Base Pay`, `Overtime Pay`, `Other Pay`)
  df$Department <- factor(df$Department, as.character(df$Department))
  df <- melt(df, id.vars="Department")
  colnames(df) <- c("Department", "Payment", "Dollars")
  ggplotly(ggplot(data = df, aes(x=Department, y=Dollars, fill=Payment)) +
             geom_bar(stat="identity", position="dodge") + coord_flip() +
             scale_x_discrete(limits = rev(levels(df$ID))))
}

full_pie <- function(df_full, year) {
  df <- df_full %>%
    filter(Year == year)
  df <- data.frame(table(df$`Employment Type`))
  colnames(df) <- c("Type", "Count")
  plot_ly(df, labels = ~`Type`, values = ~Count, textposition = 'inside',
          textinfo = 'percent') %>%
    add_pie(hole=0.5)
}


# User Interfece

ui <- dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Payroll Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Annual Total Payroll", tabName = "total", icon = icon("city")),
      menuItem("Top Employee Payroll", tabName = "employee", icon = icon("user-tie")),
      menuItem("Department Payroll Average", tabName = "department", icon = icon("search-dollar")),
      menuItem("Top Department Payroll", tabName = "department2", icon = icon("users")),
      menuItem("Full/Part Time", tabName = "full", icon = icon("hourglass-start"))
    )
  ),
  dashboardBody(
    tabItems(
      # first tab
      tabItem(tabName = "total",
              fluidRow(
                column(3,
                       box(width = NULL,
                           selectInput("year", h3("Select Year"), 
                                       choices = c("2013" = 2013,
                                                   "2014" = 2014,
                                                   "2015" = 2015,
                                                   "2016" = 2016,
                                                   "2017" = 2017,
                                                   "2018" = 2018,
                                                   "2013-2018" = "Overall"),
                                       selected = "Overall"))
                ),
                column(9,
                       box(width = NULL, solidHeader = TRUE,
                           plotlyOutput("pie")
                       )
                )
              ) 
      ),
      
      # second tab
      tabItem(tabName ="employee",
              fluidRow(
                column(3,
                       box(width = NULL,
                           selectInput("year2", h3("Select Year"), 
                                       choices = c("2013" = 2013,
                                                   "2014" = 2014,
                                                   "2015" = 2015,
                                                   "2016" = 2016,
                                                   "2017" = 2017,
                                                   "2018" = 2018),
                                       selected = "2017"),
                           numericInput("number2", h3("Number of Employees"), 
                                        value = 10))
                ),
                column(9,
                       box(width = NULL, solidHeader = TRUE,
                           plotlyOutput("employeebar")
                       )
                )
              )
      ),
      
      # third tab: departmental payroll
      tabItem(tabName = "department",
              fluidRow(
                column(3,
                       box(width = NULL,
                           selectInput("year3", h3("Year Selection"), 
                                       choices = c("2013" = 2013,
                                                   "2014" = 2014,
                                                   "2015" = 2015,
                                                   "2016" = 2016,
                                                   "2017" = 2017,
                                                   "2018" = 2018),
                                       selected = "2017"),
                           selectInput("method", h3("Select Method"), 
                                       choices = c("Mean",
                                                   "Median"),
                                       selected = "Median"),
                           numericInput("number3", h3("Number of Departments"), 
                                        value = 5))
                ),
                column(9,
                       box(width = NULL, solidHeader = TRUE,
                           plotOutput("density"))
                )
              )
      ),
      # fourth tab
      tabItem(tabName = "department2",
              fluidRow(
                column(3,
                       box(width = NULL,
                           selectInput("year4", h3("Year Selection"), 
                                       choices = c("2013" = 2013,
                                                   "2014" = 2014,
                                                   "2015" = 2015,
                                                   "2016" = 2016,
                                                   "2017" = 2017,
                                                   "2018" = 2018),
                                       selected = "2017"),
                           numericInput("number4", h3("Number of Departments"), 
                                        value = 5))
                ),
                column(9,
                       box(width = NULL, solidHeader = TRUE,
                           plotlyOutput("department")
                       )
                )
              )
              
      ),
      #fifth tab
      tabItem(tabName = "full",
              fluidRow(
                column(3,
                       box(width = NULL,
                           selectInput("year5", h3("Year Selection"), 
                                       choices = c("2013" = 2013,
                                                   "2014" = 2014,
                                                   "2015" = 2015,
                                                   "2016" = 2016,
                                                   "2017" = 2017,
                                                   "2018" = 2018),
                                       selected = "2017"))
                ),
                column(9,
                       box(width = NULL, solidHeader = TRUE,
                           plotlyOutput("full")
                       )
                )
              )
      )
    )
  )
)


# Server

server <- function(input, output) {
  # first tab
  output$pie <- renderPlotly({
    if(input$year == "Overall"){
      overall_barplot(df_year)
    }else{
      pie_chart(df_year, input$year)
    }
  })
  
  # tab 2
  output$employeebar <- renderPlotly({
    employee_barplot(df_employee, input$year2, input$number2)
  })
  
  # tab 3
  output$density <- renderPlot({
    if(input$method == "Median"){
      density_median(df_department, input$year3, input$number3)
    }else{
      density_mean(df_department, input$year3, input$number3)
    }
  })
  
  # tab 4
  output$department <- renderPlotly({
    plot_department_cost(df_department_cost, input$year4, input$number4)
  })
  
  # tab 5
  output$full <- renderPlotly({
    full_pie(df_full, input$year5)
  })
  
}

# Run 
shinyApp(ui = ui, server = server)