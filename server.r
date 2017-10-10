library(shiny)
library(shinydashboard)
library(shinyBS)
library(RJSONIO)
library(RCurl)

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



shinyServer(function(input, output,session) {
  isolate({updateTabItems(session, "tabs", "best_heroes")})
  updateSelectizeInput(session,"heroes_select",choices=all_heroes[,1])
  updateSelectizeInput(session,"map_select",choices=all_map[,1])
  
  # observeEvent(input$heroes_select,{
  #   print(paste0("https://d1i1jxrdh2kvwy.cloudfront.net/Images/Heroes/Portraits/",
  #                gsub("'","",gsub(" ","",gsub("\\.","",input$heroes_select))),".png"))
  #   output$myImage <- renderImage({
  # 
  #     
  #     # Return a list containing the filename
  #     list(src = paste0("https://d1i1jxrdh2kvwy.cloudfront.net/Images/Heroes/Portraits/",
  #                       gsub("'","",gsub(" ","",gsub("\\.","",input$heroes_select))),".png"),
  #          contentType = 'image/png',
  #          width = 20,
  #          height = 20)
  #   }, deleteFile = TRUE)
  # })

  
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
  
  
})


#deployApp("C:\\Users\\rmayer\\Desktop\\hots_app")