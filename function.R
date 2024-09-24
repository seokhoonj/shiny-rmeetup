
fileBox <- function(
    ...,
    title = "Files", footer = NULL, status = "warning",
    solidHeader = TRUE, background = NULL,
    width = 13, height = NULL,
    collapsible = FALSE, collapsed = FALSE
) {
  box(
    ...,
    title = title, footer = footer, status = status,
    solidHeader = solidHeader, background = background,
    width = width, height = height,
    collapsible = collapsible, collapsed = collapsed
  )
}

conditionBox <- function(
    ...,
    title = "Conditions", footer = NULL, status = "danger",
    solidHeader = TRUE, background = NULL,
    width = 13, height = NULL,
    collapsible = FALSE, collapsed = FALSE
) {
  box(
    ...,
    title = title, footer = footer, status = status,
    solidHeader = solidHeader, background = background,
    width = width, height = height,
    collapsible = collapsible, collapsed = collapsed
  )
}

resultBox <- function(
    ...,
    title = "생산성 향상을 위한 나만의 R 패키지", footer = NULL, status = "success",
    solidHeader = TRUE, background = NULL,
    width = 13, height = NULL,
    collapsible = FALSE, collapsed = FALSE
) {
  box(
    ...,
    title = title, footer = footer, status = status,
    solidHeader = solidHeader, background = background,
    width = width, height = height,
    collapsible = collapsible, collapsed = collapsed
  )
}

resultTabBox <- function(
    ...,
    id = NULL, selected = NULL, title = NULL,
    width = 13, height = NULL,
    side = c("left", "right")
) {
  tabBox(
    ...,
    id = id, selected = selected, title = title,
    width = width, height = height, side = side
  )
}