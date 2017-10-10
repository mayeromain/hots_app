library(shiny)
library(shinydashboard)
library(shinyBS)

skin <- "blue"

tag_name_corr <- c("Bastien","Dorian","Balazs","Romain","Alban","Grégoire","Kevin")
names(tag_name_corr) <- c("B4BOU","Coconel","Glamèche","Bananouya","Bababou","Gesk","Lecremeux")

# sidebar ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
sidebar <- dashboardSidebar(
  sidebarMenu(id="tabs",
              sidebarMenuOutput("menu")
  )
)

# body ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
body <- dashboardBody(
  tabItems(
    tabItem("best_heroes",
            fluidRow(box(
              title="Select your Tag",width = 4, solidHeader = T,
              selectizeInput("tag_selected","Choose your Tag",tag_name_corr),
              selectizeInput("map_select","Choose your Map",c("waiting or update")),
              selectizeInput("heroes_select","Choose your Heroes",c("waiting or update")),
              uiOutput(outputId = "skill_on_hero")
            )
            )
            )
    )
  )

# header ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
header <- dashboardHeader(
  title = paste0("Team Puceau Official Webapp"),
  titleWidth = 400
  #   notifications,
  #   tasks
)

# final dashboard creation ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
dashboardPage(title = "Team Puceau United",header,sidebar,body, skin = skin)
