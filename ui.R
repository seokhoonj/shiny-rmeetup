
source("library.R")
source("function.R")
source("global.R")
options(shiny.maxRequestSize = 50*1024^2)
options(scipen = 999)

# ui ----------------------------------------------------------------------

ui <- dashboardPage(
  skin = "black",
  title = "R Meetup",

# . -----------------------------------------------------------------------

# ui - header -------------------------------------------------------------
  
  dashboardHeader(
    title = span("알 미트업, 주석훈"),
    titleWidth = 250
  ), # dashboardHeader

# . -----------------------------------------------------------------------

# ui - sidebar ------------------------------------------------------------
  
  dashboardSidebar(
    width = 250,
    
    sidebarMenu(
      id = "sidebarId",

# ui - sidebar - presentation ---------------------------------------------

      menuItem(
        text = "Presentation",
        tabName = "pkg_pt_tab",
        startExpanded = TRUE,
        menuSubItem("Introduction" , tabName = "pkg_pt_tab_intro", selected = TRUE),
        menuSubItem("Top Downloads", tabName = "pkg_pt_tab_top_pkg"),
        menuSubItem("Productivity" , tabName = "pkg_pt_tab_productivity"),
        menuSubItem("Environment"  , tabName = "pkg_pt_tab_env"),
        menuSubItem("KOSIS"        , tabName = "pkg_pt_tab_kosis")
      ),
      
# ui - sidebar - structure ------------------------------------------------

      menuItem(
        text = "Package Structure",
        tabName = "pkg_strt_tab",
        startExpanded = TRUE,
        menuSubItem("DESCRIPTION", tabName = "pkg_strt_tab_descr"),
        menuSubItem("NAMESPACE"  , tabName = "pkg_strt_tab_ns"),
        menuSubItem("R"          , tabName = "pkg_strt_tab_r"),
        menuSubItem("man"        , tabName = "pkg_strt_tab_man")
      ),

# ui - sidebar - development ----------------------------------------------
      
      menuItem(
        text = "Package Development",
        tabName = "pkg_dev_tab",
        startExpanded = TRUE,
        menuSubItem("usethis" , tabName = "pkg_dev_tab_usethis"),
        menuSubItem("roxygen2", tabName = "pkg_dev_tab_roxygen2"),
        menuSubItem("devtools", tabName = "pkg_dev_tab_devtools"),
        menuSubItem("testthat", tabName = "pkg_dev_tab_testthat")
      ),

# ui - sidebar - extension ------------------------------------------------
      
      menuItem(
        text = "Extending R package",
        tabName = "pkg_ext_tab",
        startExpanded = TRUE,
        menuSubItem("C, C++" , tabName = "pkg_ext_tab_c"),
        menuSubItem("Python" , tabName = "pkg_ext_tab_py"),
        menuSubItem("ggplot2", tabName = "pkg_ext_tab_gg"),
        menuSubItem("Shiny"  , tabName = "pkg_ext_tab_shiny")
      ),

# ui - sidebar - reference ------------------------------------------------
      
      menuItem(
        text = "Reference",
        tabName = "pkg_ref_tab",
        startExpanded = TRUE,
        menuSubItem("Website", tabName = "pkg_ref_tab_web")
      )
      
    ) # sidebarMenu
    
  ), # dashboardSidebar

# . -----------------------------------------------------------------------

# ui - body ---------------------------------------------------------------

  dashboardBody(
    tags$head(
      tags$style(
        HTML(
        "
        .multicol {
            /*font-size:12px;*/
            -webkit-column-count: 2; /* Chrome, Safari, Opera */
            -moz-column-count: 2;    /* Firefox */
            column-count: 2;
            -moz-column-fill: auto;
            -column-fill: auto;
        }
        section.sidebar .shiny-input-container {
            padding: 9px 15px 0px 15px;
            white-space: normal;
        }
        div.checkbox {
            margin-top: 10px;
        }
  
        /* tabBox background */
        .nav-tabs-custom {
            border: 1px solid #00a65a;
        }
        .nav-tabs-custom > .nav-tabs {
            background: #00a65a;
            border-top-right-radius: 3px;
            border-top-left-radius: 3px;
        }
        .nav-tabs-custom > .nav-tabs > li.header {
            color: white;
        }
        .nav-tabs-custom > .tab-content {
            padding: 10px;
            border-bottom-color: #00a65a;
            border-bottom-right-radius: 3px;
            border-bottom-left-radius: 3px;
        }
        .nav-tabs-custom .nav-tabs li.active {
            border-top-color: #00a65a;
        }
        .nav-tabs-custom > .nav-tabs > li > a {
            color: #FFF;
        }
        .nav-tabs-custom > .nav-tabs > li.active > a, .nav-tabs-custom > .nav-tabs > li.active:hover > a {
            color: #00a65a;
        }
        /* .dataTables_length {} */
              .dt-buttons {
            margin-left: 10px;
        }"
        )
      )
    ),
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "style.css"
    ),
    
    useShinyjs(),
    
    tabItems(

# ui - body - presentation ------------------------------------------------
      
      tabItem(
        tabName = "pkg_pt_tab_intro",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                slickROutput("pkg_pt_tab_intro_pt") |> withSpinner()
              )
            )
          )
        )
      ),

      tabItem(
        tabName = "pkg_pt_tab_top_pkg",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                plotOutput("pkg_pt_tab_top_pkg_plot") |> withSpinner(),
                includeMarkdown(
                  path = "contents/package_status.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_pt_tab_productivity",
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
        tabName = "pkg_pt_tab_env",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/development_environment.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_pt_tab_kosis",
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

# ui - body - structure ---------------------------------------------------
   
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
      ),

# ui - body - development -------------------------------------------------
     
      tabItem(
        tabName = "pkg_dev_tab_usethis",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/usethis_package.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_dev_tab_roxygen2",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/roxygen2_package.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_dev_tab_devtools",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/devtools_package.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_dev_tab_testthat",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/testthat_package.md"
                )
              )
            )
          )
        )
      ),

# ui - body - extension ---------------------------------------------------
      
      tabItem(
        tabName = "pkg_ext_tab_c",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/c_extension.md"
                )
              )
            )
          )
        )
      ),
      
      tabItem(
        tabName = "pkg_ext_tab_py",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/python_extension.md"
                )
              )
            )
          )
        )
      ),

      tabItem(
        tabName = "pkg_ext_tab_gg",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/ggplot2_extension.md"
                )
              )
            )
          )
        )
      ),

      tabItem(
        tabName = "pkg_ext_tab_shiny",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/shiny_extension1.md"
                ),
                conditionBox(
                  width = 13,
                  title = "shinymodules selectUI & dynSelectServer",
                  fluidRow(
                    column(width = 4, shinymodules::selectUI(id = "new_id1", "vs")),
                    column(width = 4, shinymodules::selectUI(id = "new_id2", "am")),
                    column(width = 4, shinymodules::selectUI(id = "new_id3", "cyl"))
                  )
                ),
                includeMarkdown(
                  path = "contents/shiny_extension2.md"
                )
              )
              # conditionBox(title = "Shiny Modules",
              #   fluidRow(
              #     column(width = 4, shinymodules::selectUI(id = "mtcars_vs", "vs")),
              #     column(width = 4, shinymodules::selectUI(id = "mtcars_am", "am")),
              #     column(width = 4, shinymodules::scalesUI(id = "mtcars_scales"))
              #   ),
              #   fluidRow(
              #     column(width = 12, plotOutput("pkg_ext_tab_shiny_plot"))
              #   )
              # )
            )
          )
        )
      ),

# ui - body - reference ---------------------------------------------------

      tabItem(
        tabName = "pkg_ref_tab_web",
        fluidPage(
          fluidRow(
            column(
              width = 12,
              resultBox(
                includeMarkdown(
                  path = "contents/reference_web.md"
                )
              )
            )
          )
        )
      )
      
    ) # tabItems
    
  ) # dashboardBody

) # dashboardPage

