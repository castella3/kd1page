library(shiny)
library(shinymaterial)
library(shinycssloaders)

ui <- material_page(
  title = "Material Design (Blue Theme)",
  font_color = "#0097a7",
  nav_bar_color = "#0097a7",
  
  material_parallax(
    image_source = "https://github.com/sasakiK/FreeStockPhotos/blob/master/pexels-photo%20(1).jpg?raw=true"
  ),
  
  material_row(tags$br(), div(h2("Features"), align = "center")),
  
  material_row(
    material_column(width = 4,
                    material_button(
                      input_id = "button",
                      label = "BUTTON",
                      depth = 5,
                      color = "#0097a7"
                    ), align = "center"),
    material_column(width = 4,
                    div("Switch", style = "text-align:center;"),
                    material_switch(
                      input_id = "switch",
                      off_label = "Off",
                      on_label = "On",
                      initial_value = FALSE
                    ), align = "center"),
    material_column(width = 4,
                    material_text_box(
                      input_id = "text_box",
                      label = "text box",
                      color = "#0097a7"
                    ), align = "center")
  ),
  
  tags$br(),
  
  material_row(
    material_column(width = 4,
                    material_dropdown(
                      input_id = "example_dropdown",
                      label = "Drop down",
                      choices = c("Chicken" = "c", "Steak" = "s", "Fish" = "f"),
                      selected = "c",
                      multiple = FALSE,
                      color = "#0097a7"
                    ), align = "center"),
    material_column(width = 4,
                    material_input(
                      type = "slider",
                      input_id = "input_slider",
                      label = "slider",
                      min_value = 5,
                      max_value = 15,
                      initial_value = 10,
                      color = "#00acc1"
                    ), align = "center"),
    material_column(width = 4,
                    material_checkbox(
                      input_id = "checkbox",
                      label = "checkbox"
                    ), align = "center")
  ),
  
  tags$br(),
  
  material_row(
    material_column(width = 4,
                    material_number_box(
                      input_id = "number_box",
                      label = "number_box",
                      min_value = 5,
                      max_value = 15,
                      initial_value = 10
                    ), align = "center"),
    material_column(width = 4,
                    material_input(
                      type = "password_box",
                      input_id = "input_password_box",
                      label = "password_box"
                    ), align = "center"),
    material_column(width = 4,
                    material_date_picker(
                      input_id = "date_picker",
                      label = "Date picker"
                    ), align = "center")
  ),
  
  tags$br(),
  
  material_row(
    material_column(width = 4,
                    material_radio_button(
                      input_id = "radio_button",
                      label = "Choose one",
                      choices = c("Option A", "Option B", "Option C")
                    )),
    material_column(width = 4,
                    material_file_input(
                      input_id = "file_input",
                      label = "Upload a file"
                    )),
    material_column(width = 4,
                    div("Histogram Output", style = "text-align:center; margin-bottom:5px;"),
                    withSpinner(plotOutput("histPlot"), color = "#0097a7", type = 6))
  ),
  
  tags$br(),
  
  material_row(
    material_column(width = 12,
                    tags$details(
                      tags$summary("More Info (クリックして開閉)"),
                      tags$p("これは折りたたみセクションの一つ目です。必要に応じて詳細な内容を書けます。"),
                      tags$ul(
                        tags$li("ポイントA"),
                        tags$li("ポイントB"),
                        tags$li("ポイントC")
                      )
                    ),
                    tags$br(),
                    tags$details(
                      tags$summary("Details (クリックして開閉)"),
                      tags$p("これは二つ目の折りたたみセクションです。HTMLタグも使用可能です。")
                    )
    )
  ),
  
  tags$br(),
  
  material_tabs(
    tabs = c("Tab 1" = "tab_1", "Tab 2" = "tab_2"),
    color = "#0097a7"
  ),
  
  material_tab_content(
    tab_id = "tab_1",
    material_row(
      material_column(width = 12,
                      div(h4("Tab 1 Content"), style = "text-align:center;"),
                      div("ここはタブ1の中身です。")
      )
    )
  ),
  
  material_tab_content(
    tab_id = "tab_2",
    material_row(
      material_column(width = 12,
                      div(h4("Tab 2 Content"), style = "text-align:center;"),
                      div("こちらはタブ2の中身です。")
      )
    )
  ),
  
  material_parallax(
    image_source = "https://github.com/sasakiK/FreeStockPhotos/blob/master/pexels-photo-247528.jpeg?raw=true"
  ),
  
  material_row(
    tags$br(), tags$br(),
    material_column(width = 12,
                    material_modal(
                      modal_id = "showcase_modal",
                      button_text = "Card",
                      button_icon = "open_in_browser",
                      title = " ",
                      div(material_card(
                        title = "Material Card",
                        img(src = "https://github.com/sasakiK/FreeStockPhotos/blob/master/pexels-photo-306533.jpeg?raw=true",
                            height = "100%", width = "100%")
                      ), align = "center")
                    ),
                    tags$br(),
                    div(helpText("@sasaki_K_sasaki"), align = "center", style = "color:#0097a7;"),
                    align = "center"
    )
  ),
  
  material_row(
    tags$br(),
    material_column(width = 12,
                    material_button(
                      input_id = "load_btn",
                      label = "データを検索",
                      color = "#0097a7",
                      depth = 3
                    ),
                    div(id = "loading_output", withSpinner(textOutput("loading_text"), type = 6, color = "#0097a7"), style = "text-align:center; margin-top:15px;")
    )
  ),
  
  material_floating_button(
    input_id = "fab_btn",
    icon = "add",
    color = "#0097a7",
    depth = 3
  )
)

server <- function(input, output, session) {
  output$histPlot <- renderPlot({
    Sys.sleep(1.5)
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$input_slider + 1)
    hist(x, breaks = bins, col = "#0097a7", border = "white",
         xlab = "Waiting time to next eruption (mins)",
         main = "Histogram of waiting times")
  })
  
  observeEvent(input$load_btn, {
    output$loading_text <- renderText({
      Sys.sleep(10)
      "検索完了"
    })
  })
}

shinyApp(ui = ui, server = server)

