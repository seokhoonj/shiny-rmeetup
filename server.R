
server <- function(input, output, session) {

# server - presentation ---------------------------------------------------
  
  output$pkg_pt_tab_intro_pt <- renderSlickR({
    imgs <- list.files("images/intro/", pattern = ".png", full.names = TRUE)
    slickR(obj = imgs, width = "95%", height = 600)
  })
  
  output$pkg_pt_tab_status_plot <- renderPlot({
    pkg_top <- cranlogs::cran_top_downloads(when = "last-month")
    pkg_top$rank <- as.factor(pkg_top$rank)
    ggbar(pkg_top, x = rank, y = count, fill = rank,
          label = package, label_size = 5, label_hjust = -.1) +
      scale_y_comma() +
      coord_flip() +
      scale_x_limit_reverse(pkg_top$rank) +
      labs(title = "CRAN Top Downloads (Monthly)") +
      theme_shiny(x.angle = 45)
  })

  output$pkg_pt_tab_kosis_md <- renderUI({
    tags$div(
      includeMarkdown(path = "contents/kosis.md"),
      tags$script("hljs.highlightAll();")  # Re-initialize after rendering
    )
  })
  
# . -----------------------------------------------------------------------
  
# server - extension ------------------------------------------------------
  
# server - extension - shiny ----------------------------------------------
  
  data <- reactive(mtcars)
  
  # example 1
  new_id1 <- shinymodules::dynSelectServer(id = "new_id1", data = data, column = "vs")
  new_id2 <- shinymodules::dynSelectServer(id = "new_id2", data = data, column = "am")
  new_id3 <- shinymodules::dynSelectServer(id = "new_id3", data = data, column = "cyl")
  
  # example 2
  # mtcars_vs <- shinymodules::dynSelectServer(id = "mtcars_vs", data = data, column = "vs")
  # mtcars_am <- shinymodules::dynSelectServer(id = "mtcars_am", data = data, column = "am")
  # mtcars_scales <- shinymodules::scalesServer(id = "mtcars_scales")
  # output$pkg_ext_tab_shiny_plot <- renderPlot({
  #   data <- data()
  #   mtcars_vs <- mtcars_vs()
  #   mtcars_am <- mtcars_am()
  #   mtcars_scales <- mtcars_scales()
  #   ggpoint(data = data[data$vs == mtcars_vs & data$am == mtcars_am,],
  #           x = hp, y = mpg, color = as.factor(cyl)) +
  #     facet_wrap(~ cyl, scales = mtcars_scales()) +
  #     ggshort::stat_mean_line() +
  #     ggshort::stat_chull(aes(fill = as.factor(cyl))) +
  #     theme_shiny(legend.position = "none")
  # })

}

