
# R 패키지 개발 시 shiny 패키지 사용법 (모듈화된 서버 함수 중심)

`shiny`는 웹 애플리케이션을 제작하는 데 유용하며, 모듈화된 서버 함수를 사용하면 대규모 애플리케이션을 더 깔끔하게 관리할 수 있습니다. 특히 모듈화된 구조는 코드 재사용성을 높이고 유지보수를 쉽게 합니다.

## 1. `shiny` 설치 및 로드

```r
install.packages("shiny")
library(shiny)
```

## 2. 기본 `shiny` 애플리케이션 구조

```r
library(shiny)

ui <- fluidPage(
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("slider", "Choose a number", 1, 100, 50)
    ),
    mainPanel(
      textOutput("result")
    )
  )
)

server <- function(input, output) {
  output$result <- renderText({
    paste("You chose:", input$slider)
  })
}

shinyApp(ui = ui, server = server)
```

## 3. 모듈화된 `shiny` 애플리케이션

모듈화된 애플리케이션은 코드의 재사용성을 높이고, 유지보수를 쉽게 합니다.

### 3.1 모듈화된 UI 정의

```r
myModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    sliderInput(ns("slider"), "Choose a number", 1, 100, 50),
    textOutput(ns("result"))
  )
}
```

### 3.2 모듈화된 서버 정의

```r
myModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$result <- renderText({
      paste("You chose:", input$slider)
    })
  })
}
```

### 3.3 모듈을 메인 애플리케이션에 통합

```r
ui <- fluidPage(
  titlePanel("Modular Shiny App"),
  myModuleUI("module1")
)

server <- function(input, output, session) {
  myModuleServer("module1")
}

shinyApp(ui = ui, server = server)
```

## 4. 모듈화된 서버에서 리액티브 값 사용

리액티브 값을 반환하거나 다른 모듈에서 받아서 사용할 수 있습니다.

### 4.1 리액티브 값 반환

```r
myModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      input$slider * 2
    })
  })
}
```

### 4.2 리액티브 값 사용

```r
ui <- fluidPage(
  titlePanel("Modular Shiny App with Reactive"),
  myModuleUI("module1"),
  textOutput("outputValue")
)

server <- function(input, output, session) {
  doubleValue <- myModuleServer("module1")
  
  output$outputValue <- renderText({
    paste("Double of chosen value:", doubleValue())
  })
}

shinyApp(ui = ui, server = server)
```

## 5. 모듈 간 통신

여러 모듈 간에 데이터를 주고받을 수 있습니다.

### 5.1 모듈 간 데이터 전달

```r
# 첫 번째 모듈
firstModuleServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive({
      input$slider
    })
  })
}

# 두 번째 모듈
secondModuleServer <- function(id, inputValue) {
  moduleServer(id, function(input, output, session) {
    output$result <- renderText({
      paste("Received value:", inputValue())
    })
  })
}

ui <- fluidPage(
  titlePanel("Module Communication"),
  myModuleUI("firstModule"),
  myModuleUI("secondModule")
)

server <- function(input, output, session) {
  firstValue <- firstModuleServer("firstModule")
  secondModuleServer("secondModule", firstValue)
}

shinyApp(ui = ui, server = server)
```

## 요약

- 모듈화된 UI와 서버 함수로 코드를 재사용하고 유지보수를 쉽게 할 수 있습니다.
- `moduleServer()` 함수로 모듈화된 서버 로직을 정의하고 관리할 수 있습니다.
- 리액티브 값을 사용하여 모듈 간 데이터를 전달하고 처리할 수 있습니다.
