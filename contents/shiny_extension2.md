## 2. 함수에서 `Shiny` App 실행 
Module화가 진행되고 나면 `Shiny` 코드를 비교적 쉽게 해체하고 재사용 할 수 있습니다.
다음은 CRAN의 Top 다운로드 패키지를 알아보는 간단한 `Shiny` App 함수의 예시입니다.

``` r
plot_cran_top <- function(when = c("last-month", "last-week", "last-day"), 
                          count = 10, viewer_width = 1200, viewer_height = 500) {
  when <- match.arg(when)
  shiny::runGadget(
    shiny::fluidPage(
      shiny::plotOutput("cran_download_plot", width = "100%", height = "500px")
    ),
    function(input, output, session) {
      output$cran_download_plot <- renderPlot({
        cran_tops <- cranlogs::cran_top_downloads(when = when, count = count)
        cran_tops$rank <- as.factor(cran_tops$rank)
        ggshort::ggbar(cran_tops, x = rank, y = count, fill = rank, 
                       label = package, label_size = 5, label_hjust = -.1) +
          ggshort::scale_y_comma() +
          coord_flip() +
          ggshort::scale_x_limit_reverse(cran_tops$rank) +
          labs(title = sprintf("Cran Top Downloads (%s)", when)) +
          ggshort::theme_shiny(x.angle = 45)
      })
    }, viewer = shiny::dialogViewer(sprintf("Cran Top Downloads %s", when), 
                                    width = viewer_width, height = viewer_height))
}

plot_cran_top()
```

![alt text](../images/plot_cran_top.gif){: width="70%"}
