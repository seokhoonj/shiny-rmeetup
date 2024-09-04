
server  <- function(input, output, session) {

# package structure -------------------------------------------------------
  
  output$pkg_stts_tab_top_dl_plot <- renderPlot({
    pkg_tops <- cranlogs::cran_top_downloads()
    pkg_tops$rank <- as.factor(pkg_tops$rank)
    ggbar(pkg_tops, x = rank, y = count, fill = rank,
          label = package, label_size = 5, label_hjust = -.1) +
      scale_y_comma() +
      coord_flip() +
      scale_x_limit_reverse(pkg_tops$rank) +
      theme_shiny(x.angle = 45)
  })
  
}
