
#### Runtime

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

### Funcions:

# Paquets(x)
Paquets <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# TaulaContinguts(x)
TaulaContinguts <- function(x) {
  data.frame(row.names = 1:length(x),
             Name = substr(names(x), 1, 19),
             Class = sapply(x, class),
             N_unique = sapply(x, function(v) length(unique(v))))
}

# Colors()
Colors <- function(nv=4){
  if(require(RColorBrewer)){
    cols=brewer.pal(nv,"Pastel1")
  }else{
    warning("This plot would like nicer if you installed RColorBrewer")
    cols=(1:nv)
  }
  return(cols)
}

#Sdbeta()
Sdbeta <- function(lm){
  b <- summary(lm)$coef[-1, 1]
  beta <- c()
  for(i in 1:length(b)){
    sx <- lm$model[-1]
    sdxi <- sd(sx[,i])
    sy <- sd(lm$model[,1])
    beta <- c(beta,b[i] * sdxi/sy)
  }
  return(beta)
}

#---
  