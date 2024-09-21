# R 패키지 개발 시 Shiny 사용법

## 1. Shiny Module

Shiny 모듈화는 코드 재사용성을 높이고 유지보수를 쉽게 만드는데 필수적입니다. 다음은 `selectInput` 드롭다운 메뉴에 대한 설명을 그 예로 하고 있습니다. 기본적으로 ui 함수에 적용될 `selectUI`와 server 함수에 포함될 `dynSelectServer`로 이루어져 있습니다. `selectServer`가 아닌 `dynSelectServer`인 이유는 인수에 따라 Reactive하게 움직이기 때문입니다.

- shinymodules: <a href= "https://github.com/seokhoonj/shinymodules/blob/main/R/select.R" target="_blank" rel="noopener noreferrer">https://github.com/seokhoonj/shinymodules/blob/main/R/select.R</a>

``` r
# selectInput의 Module UI (드롭다운 메뉴)
selectUI <- function(id, label = "Select", choices = NULL, selected = NULL, 
                     multiple = FALSE) {
    ns <- NS(id) # 모듈의 네임스페이스 설정
    tagList(selectInput(ns("select"), label = label, choices = choices, 
            selected = selected, multiple = multiple))
}

# 특정 컬럼의 유니크한 값들이 selectInput의 값이 되는 Module Server
# 여기서 인수가 되는 data는 반드시 reactive가 적용된 데이터여야 합니다.
dynSelectServer <- function(id, data, column, selected = NULL, reverse = FALSE) {
    moduleServer(id, function(input, output, session) {
        ns <- session$ns # 모듈의 네임스페이스 생성
        observeEvent(data(), {
            dt <- data()
            choices <- sort(unique(dt[[column]]))
            if (reverse) 
                choices <- rev(choices)
            updateSelectInput(session, inputId = "select", choices = choices, 
                selected = selected)
        })
        select <- reactive({
            validate(need(input$select, message = FALSE))
            input$select
        })
        return(select)
    })
}
```

``` r
ui <- fluidPage(
  fluidRow(
    column(width =  4, selectUI(id = "new_id1")),
    column(width =  4, selectUI(id = "new_id2")),
    column(width =  4, selectUI(id = "new_id3"))
  )
)

server <- function(input, output, session) {
    data <- reactive(mtcars)
    new_id1 <- dynSelectServer(id = "new_id1", data = data(), selected = "vs")
    new_id2 <- dynSelectServer(id = "new_id2", data = data(), selected = "am")
    new_id3 <- dynSelectServer(id = "new_id2", data = data(), selected = "cyl")
}
```
