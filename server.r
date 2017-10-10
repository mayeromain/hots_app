library(shiny)
library(shinydashboard)
library(shinyBS)
library(RJSONIO)
library(RCurl)
library(gsheet)
library(readr)

# precise then encoding for the app
options(encoding = "UTF-8")

# grab the heroes data from hotslog
raw_data <- getURL("https://api.hotslogs.com/Public/Data/Heroes")
# Then covert from JSON into a list in R
data <- fromJSON(raw_data)

# We can coerce this to a data.frame
all_heroes <- do.call(rbind, data)
all_heroes <- all_heroes[,-dim(all_heroes)[2]]

# grab the maps data from hotslog
raw_data <- getURL("https://api.hotslogs.com/Public/Data/Maps")
# Then covert from JSON into a list in R
data <- fromJSON(raw_data)

# We can coerce this to a data.frame
all_map <- do.call(rbind, data)
all_map <- all_map[,-dim(all_map)[2]]

url <- 'https://docs.google.com/spreadsheets/d/12e4Q5PdyAaqR7zeakZuTHShtask9aUo3mcLUuJvoWPI/edit#gid=0'
our_skill_data <- read_csv(construct_download_url(url))

shinyServer(function(input, output,session) {
  isolate({updateTabItems(session, "tabs", "best_heroes")})
  updateSelectizeInput(session,"heroes_select",choices=all_heroes[,1])
  updateSelectizeInput(session,"map_select",choices=all_map[,1])
  
  output$menu <- renderMenu({
    sidebarMenu(
    
    sidebarUserPanel(name = "Puceau Connected" ,subtitle = a(icon("circle", class = "text-success"), "Online",br(),
                                  newtab = F,
                                  tags$head(tags$style(".butt1{background-color:orange;} .butt1{color: black;} .butt1{font-family: Courier New}"))),
                     # Image file should be in www/ subdir
                     image = paste0("https://d1i1jxrdh2kvwy.cloudfront.net/Images/Heroes/Portraits/",
                                    gsub("'","",gsub(" ","",gsub("\\.","",input$heroes_select))),".png")
    ),
     
    br(),
    tags$hr(),
    menuItem("Hots Screening", icon = icon("dashboard"),
             menuSubItem("Best Heroes", tabName = "best_heroes",icon = icon("dashboard"))
    )
  )
  })
  
  observeEvent(c(input$tag_selected,input$heroes_select),{

    row_temp <- which(toupper(gsub("'","",gsub(" ","",gsub("\\.","",our_skill_data$Héros)))) ==  toupper(gsub("'","",gsub(" ","",gsub("\\.","",input$heroes_select)))))
    col_temp <- which(colnames(our_skill_data)== input$tag_selected)
    
    if(length(row_temp)!=0 && length(col_temp)!=0){
    # print(row_temp)
    # print(col_temp)
    # print(as.character(our_skill_data[row_temp,col_temp]))
    
    skill <- (our_skill_data[row_temp,col_temp])
    skill_text <- paste0(ifelse(as.numeric(skill) ==1,
                  "<font color = 'green'>You ranked your skill with this hero as 1 Good Choice!",
                  ifelse(as.numeric(skill) ==2,
                         "<font color = 'orange'>You ranked your skill with this hero as 2 still confident?",
                         ifelse(as.numeric(skill) > 2,
                                "<font color = 'red'>You ranked your skill with this hero 3 or wors don't choose it please!!",
                                "<font color = 'red'>You ranked your skill with this hero 3 or wors don't choose it please!!"))))
    
    output$skill_on_hero <- renderUI({span(HTML(paste0(skill_text)))})
    
    }
  })
  
  
})


#rsconnect::deployApp("C:\\Users\\rmayer\\Desktop\\hots_app")