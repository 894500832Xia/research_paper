library(shiny)

ui <- fluidPage(
  titlePanel("Chatbox for Residency"),
  
  tags$style(HTML("
    .chat-box {
      border: 1px solid #ccc;
      border-radius: 10px;
      padding: 10px;
      height: 300px;
      overflow-y: auto;
      background-color: #f9f9f9;
    }
    .user-message {
      color: blue;
      margin-bottom: 5px;
    }
    .bot-message {
      color: green;
      margin-bottom: 10px;
    }
  ")),
  
  mainPanel(
    div(class = "chat-box", htmlOutput("chat")),
    textInput("user_input", "you question:", ""),
    actionButton("send", "send")
  )
)

server <- function(input, output, session) {
  chat_history <- reactiveVal(character())
  
  observeEvent(input$send, {
    req(input$user_input != "")
    
    user_input <- input$user_input
    user_msg <- paste0("<div class='user-message'><b>Question：</b> ", user_input, "</div>")
    
    bot_reply_text <- switch(
      user_input,
      "I have dietary restrictions—what are my options?"= "NEC dining services offer vegetarian, vegan, and gluten-free options. You can also notify them in advance about specific allergies or needs.",
      "What are some recommended hotels near NEC?"= "Here are some nearby hotels:(newengland.viewpage.co)
        Concord, NH (20–25 minutes from campus): 
        Tru by Hilton Concord 
        Holiday Inn (Downtown Concord) 
        Courtyard by Marriott 
        Concord-Bow Hampton Inn 
        Manchester, NH (35–45 minutes from campus): 
        DoubleTree by Hilton (Manchester Downtown) 
        Best Western 
        Country Inn & Suites (Manchester Airport) 
        Nashua, NH (45–60 minutes from campus): 
        Hampton Inn 
        Homewood Suites by Hilton 
        Residence Inn by Marriott 
        Sunapee, NH (25 minutes from campus): 
        Bluebird Hotel",
      "Does NEC provide transportation during residency weekends?"="No, students are responsible for their own transportation. It's important to note that ride-sharing services like Uber and Lyft may be limited in Henniker, NH. Therefore, it's advisable to arrange alternative transportation methods in advance. (newengland.viewpage.co)",
      "What are the nearest airports to NEC?"="The closest airports are:(newengland.viewpage.co)Manchester-Boston Regional Airport: Approximately 40 minutes from campus. 
               Boston Logan International Airport: Approximately 1.5 hours from campus. 
                For bus transportation, services like Greyhound and Concord Coach Lines operate routes to Concord, NH. (newengland.viewpage.co)",
      "Are meals provided during the residency weekend?"="Yes, NEC provides lunches and morning/afternoon snacks (including coffee, tea, and water) on Friday, Saturday, and Sunday of the residency weekend. (newengland.viewpage.co)",
      "I don't understand."
    )
    
    bot_reply <- paste0("<div class='bot-message'><b>Chatbox：</b> ", bot_reply_text, "</div>")
    
    chat_history(c(chat_history(), user_msg, bot_reply))
    
    updateTextInput(session, "user_input", value = "")
  })
  
  output$chat <- renderUI({
    HTML(paste(chat_history(), collapse = ""))
  })
}

shinyApp(ui = ui, server = server)
