
##### User Interface

# Encoding: UTF-8

library("shinydashboard") # Shiny dashboard
library("shinycssloaders") # Animated CSS loader
library("shinyalert") # Shiny Alerts
library("shinyWidgets") # Shiny Widgets
library("shinytest") # For testing 
library("shinyjs") # JavaScript
library("dplyr") # Dplyr
library("markdown")
library("lmtest")
library("mctest")
library("lm.beta")
library("visreg")
library("caret")
library("DT")

### Title:

header <- dashboardHeader(title = "ShinyReg")

### SideBar:

sidebar <- dashboardSidebar(width = 230,
                          
                            sidebarMenu(
                              
                              menuItem("Home", tabName = "home", icon = icon("home", lib = "glyphicon")),
                              menuItem("Data", tabName = "data", icon = icon("cloud-upload", lib = "glyphicon")),
                              menuItem("Summary", tabName = "summary", icon = icon("stats", lib = "glyphicon")),
                              menuItem("Regression", tabName = "regression", icon = icon("cog", lib = "glyphicon")),
                              menuItem("Diagnostics", tabName = "diagnostics", icon = icon("cog", lib = "glyphicon")),
                              menuItem("Parameters", tabName = "parameters", icon = icon("cog", lib = "glyphicon")),
                              menuItem("Graphics", tabName = "graphics", icon = icon("cog", lib = "glyphicon")),
                              menuItem("Inference", tabName = "inference", icon = icon("cog", lib = "glyphicon")),
                              menuItem("About", tabName = "about", icon = icon("user", lib = "glyphicon")),
                              
                              hr(),
                              
                              helpText("Developed by ", 
                                       a("Ignasi Pascual", href = "https://github.com/ipveka"),
                                       align = "center")
                              
                            )
)

### Dashboard:

body <- dashboardBody(
  
  # CSS 
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  # Tabintes:
  tabItems(
    
    ### TAB 0 = Home:
    
    tabItem(tabName = "home",
            fluidPage(
              box(width = 12,
                  shiny::includeMarkdown("Home.md"),
                  tags$style(type="text/css",
                             ".shiny-output-error { visibility: hidden; }",
                             ".shiny-output-error:before { visibility: hidden; }"
                  ),
                  tags$head(tags$style(HTML('
                                            .main-header .logo {
                                            font-family: "Georgia", Times, "Times New Roman", serif;
                                            font-weight: bold;
                                            font-size: 20px;
                                            }
                                            ')))))
            
    ),
    
    ### TAB 1 = Data:
    tabItem(tabName = "data",
            fluidRow(column(4, box(width = 16,
                                   # Input: Select a file ----
                                   fileInput("file1", "Choose CSV File",
                                             multiple = FALSE,
                                             accept = c("text/csv",
                                                        "text/comma-separated-values,text/plain",
                                                        ".csv")),
                                   # Horizontal line ----
                                   tags$hr(),
                                   # Input: Checkbox if file has header ----
                                   checkboxInput("header", "Header", TRUE),
                                   # Input: Select separator ----
                                   radioButtons("sep", "Separator",
                                                choices = c(Comma = ",",
                                                            Semicolon = ";",
                                                            Tab = "\t"),
                                                selected = ","),
                                   # Input: Select quotes ----
                                   radioButtons("quote", "Quote",
                                                choices = c(None = "",
                                                            "Double Quote" = '"',
                                                            "Single Quote" = "'"),
                                                selected = '"')
            )),
            column(8, box(width = 16, DT::dataTableOutput("table", width = 650))
            ))
    ),
    
    ### TAB 2 = Summary:
    tabItem(tabName = "summary",
            fluidRow(
              column(4, box(width = 16,title = "Summary",
                            solidHeader = FALSE,
                            DT::dataTableOutput(outputId = "toc"),
                            tags$hr(),
                            uiOutput('select'),
                            tags$hr(),
                            DT::dataTableOutput("summary"))),
              column(8, box(width = 16,title = "Graphics",
                            solidHeader = FALSE,
                            withSpinner(plotOutput('plot1')),
                            withSpinner(plotOutput('plot2')),
                            withSpinner(plotOutput('plot3')))))
    ),
    
    ### TAB 3 = Regression:
    tabItem(tabName = "regression",
            fluidRow(column(4, box(width = 16,
                                   uiOutput("model_select"),
                                   uiOutput("var1_select"),
                                   uiOutput("rest_var_select"))),
                     column(8, box(width = 16,mainPanel( helpText("Your Selected variables"),
                                                         verbatimTextOutput("other_val_show")))))
    ),
    
    ### TAB 4 = Graphs:
    tabItem(tabName = "diagnostics",
            fluidRow(
              column(12,box(width = 12,title = "Anova",
                            p("Anova test, used to analyze the differences among group means in a sample. (in this case, full dataset)",
                              solidHeader = FALSE, 
                              DT::dataTableOutput(outputId = "anova"))))),
            fluidRow(
              column(6,box(width = 12,title = "Joint Significance",
                           p("Testing if all of the regression parameters are zero"),
                           solidHeader = FALSE, 
                           DT::dataTableOutput(outputId = "model"))),
              column(6,box(width = 12,title = "Determination",
                           p("Proportion of the variance in the dependent variable that is predictable from the independent variable(s)"),
                           solidHeader = FALSE, 
                           DT::dataTableOutput(outputId = "deter")))),
            fluidRow(
              column(6,box(width = 12,
                           title = "Residuals vs Fitted",
                           solidHeader = TRUE, status = "primary",
                           withSpinner(plotOutput(outputId = "reg1")))),
              column(6,box(width = 12,
                           title = "Normal Q-Q",
                           solidHeader = TRUE, status ="primary",
                           withSpinner(plotOutput(outputId = "reg2"))))
            ),
            fluidRow(
              column(6,box(width = 12,
                           title = "Cook's distance",
                           solidHeader = TRUE, status = "primary",
                           withSpinner(plotOutput(outputId = "reg4")))),
              column(6,box(width = 12,
                           title = "Residuals vs Leverage",
                           solidHeader = TRUE, status = "primary",
                           withSpinner(plotOutput(outputId = "reg5")))))
    ),
    
    ### TAB  5 = Parameters
    tabItem(tabName = "parameters",
            fluidRow(column(12,
                            box(width = 12,title = "Summary",
                                p("Summary of parameters"),
                                solidHeader = FALSE, 
                                DT::dataTableOutput(outputId = "reg")))),
            fluidRow(column(6,
                            box(width = 12,title = "Confidence intervals: Parameter Estimate",
                                p("Summary of parameters: Confidence intervals"),
                                solidHeader = FALSE,
                                DT::dataTableOutput(outputId = "confint1"))),
                     column(6,
                            box(width = 12,title = "Confidence intervals: Standardized Parameter Estimate",
                                p("Summary of standardized parameters: Confidence intervals"),
                                solidHeader = FALSE,
                                DT::dataTableOutput(outputId = "confint2"))))
    ),
    
    ### TAB 6 = Graphics
    tabItem(tabName = "graphics",
            fluidRow(box(width=12,column(12, align="center",
                                         uiOutput("var_plot")))),
            fluidRow(box(width=12,
                         h6("Plotting the relation between variables", align = "center"),
                         column(12, align="center", 
                                mainPanel(plotOutput(outputId = "visreg"),
                                          width = "100%", height = "600px"
                                ))))
    ),
    
    ### TAB 7 = Inference:
    tabItem(tabName = "inference",
            fluidRow(column(12, 
                            box(width = 4,title = "Homocedasticity: White",
                                p("Testing the null hypothesis of homcedasticity"),
                                solidHeader = FALSE, 
                                DT::dataTableOutput(outputId = "white")),
                            box(width = 4,title = "Homocedasticity: Breusch-Pagan",
                                p("Testing the null hypothesis of homcedasticity"),
                                solidHeader = FALSE, 
                                DT::dataTableOutput(outputId = "pagan")),
                            box(width = 4,title = "Autocorrelation: Durbin",
                                p("Testing the null hypothesis that errors are uncorrelated"),
                                solidHeader = FALSE, 
                                DT::dataTableOutput(outputId = "durbin")))),
            fluidRow(column(12,
                            box(width = 12,title = "Linearity: Reset",
                                p("Testing the linearity of the model"),
                                solidHeader = FALSE, 
                                DT::dataTableOutput(outputId = "reset"))))
    ),
    
    ### TAB 8 = About
    tabItem(tabName = "about",
            fluidPage(
              box(width = 12,
                  shiny::includeMarkdown("README.md"))
            )
    )
  )
)

ui <- dashboardPage(header, sidebar, body)

#---
