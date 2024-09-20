
server  <- function(input, output, session) {

# server - presentation ---------------------------------------------------
  
  output$pkg_pt_tab_top_pkg_plot <- renderPlot({
    pkg_top <- cranlogs::cran_top_downloads()
    pkg_top$rank <- as.factor(pkg_top$rank)
    ggbar(pkg_top, x = rank, y = count, fill = rank,
          label = package, label_size = 5, label_hjust = -.1) +
      scale_y_comma() +
      coord_flip() +
      scale_x_limit_reverse(pkg_top$rank) +
      theme_shiny(x.angle = 45)
  })
  
}
