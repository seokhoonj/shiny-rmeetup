
source("library.R")
source("function.R")
source("global.R")
options(shiny.maxRequestSize = 50*1024^2)
options(scipen = 999)

# ui ----------------------------------------------------------------------

ui <- dashboardPage(
  skin = "black",
  title = "R Meetup",

# ui - header -------------------------------------------------------------
  
  dashboardHeader(
    title = span("알 미트업, 주석훈"),
    titleWidth = 250
  ), # dashboardHeader

# ui - sidebar ------------------------------------------------------------
  
  dashboardSidebar(
    width = 250,
    
    sidebarMenu(
      id = "sidebarId",
      
      menuItem(
        text = "Package Status",
        tabName = "pkg_stts_tab",
        startExpanded = TRUE,
        menuSubItem("Top Downloads", tabName = "pkg_stts_tab_top_dl"),
        menuSubItem("Productivity" , tabName = "pkg_stts_tab_productivity"),
        menuSubItem("Examples"     , tabName = "pkg_stts_tab_ex"),
        menuSubItem("KOSIS"        , tabName = "pkg_stts_tab_kosis")
      ),
      
      menuItem(
        text = "Package Structure",
        tabName = "pkg_strt_tab",
        startExpanded = TRUE,
        menuSubItem("DESCRIPTION", tabName = "pkg_strt_tab_descr"),
        menuSubItem("NAMESPACE"  , tabName = "pkg_strt_tab_ns"),
        menuSubItem("R"          , tabName = "pkg_strt_tab_r"),
        menuSubItem("man"        , tabName = "pkg_strt_tab_man")
      ),
      
      menuItem(
        text = "Package Development",
        tabName = "pkg_dev_tab",
        startExpanded = TRUE,
        menuSubItem("usethis" , tabName = "pkg_dev_tab_usethis"),
        menuSubItem("roxygen2", tabName = "pkg_dev_tab_roxygen"),
        menuSubItem("devtools", tabName = "pkg_dev_tab_devtools"),
        menuSubItem("testthat", tabName = "pkg_dev_tab_testthat")
      ),
      
      menuItem(
        text = "Extending R package",
        tabName = "pkg_ext_tab",
        startExpanded = TRUE,
        menuSubItem("C, C++" , tabName = "pkg_ext_tab_c"),
        menuSubItem("Python" , tabName = "pkg_ext_tab_py"),
        menuSubItem("ggplot2", tabName = "pkg_ext_tab_gg"),
        menuSubItem("Shiny"  , tabName = "pkg_ext_tab_shiny")
      ),
      
      menuItem(
        text = "Summary",
        tabName = "pkg_smry_tab",
        startExpanded = TRUE,
        menuSubItem("Summary"  , tabName = "pkg_smry_tab_smry"),
        menuSubItem("Reference", tabName = "pkg_smry_tab_ref")
      )
      
    ) # sidebarMenu
  ), # dashboardSidebar

# ui - body ---------------------------------------------------------------

  dashboardBody(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "style.css"
    ),
    
    useShinyjs(),
    
    tabItems(
      
      tabItem(
        tabName = "pkg_stts_tab_top_dl",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                plotOutput("pkg_stts_tab_top_dl_plot") %>% withSpinner(),
                includeMarkdown(
                  path = "contents/package_status.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_stts_tab_productivity",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/package_productivity.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_stts_tab_ex",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/package_examples.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_stts_tab_kosis",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/kosis_package_development.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_strt_tab_descr",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/description.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_strt_tab_ns",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/namespace.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_strt_tab_r",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/r_folder.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_strt_tab_man",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/man_folder.md"
                )
              )
            )
          )
        )
      )
      
    ) # tabItems
    
  ) # dashboardBody

) # dashboardPage

