# R 패키지 개발 참고 자료

R 패키지 개발에 도움이 되는 C, C++, Shiny 모듈 개발 관련 웹사이트와 문서를 정리한 자료입니다. R 패키지의 성능 향상을 위해 C/C++ 통합, Shiny 모듈화를 포함한 고급 개발 기술을 다룹니다.

### R 패키지 개발 가이드

1.  **R Packages by Hadley Wickham**

    -   URL: <a href="https://r-pkgs.org/" target="_blank" rel="noopener noreferrer">r-pkgs.org</a>
    -   설명: R 패키지 개발을 위한 가이드북입니다. 패키지 구조, 문서화, 테스트, 배포까지의 모든 과정을 상세하게 설명합니다.<br><br>

2.  **Advanced R by Hadley Wickham**

    -   URL: <a href="https://adv-r.hadley.nz/" target="_blank" rel="noopener noreferrer">adv-r.hadley.nz</a>
    -   설명: R의 고급 기능과 프로그래밍 개념을 설명하며, 패키지 개발의 심화 내용을 다룹니다.<br><br>

3.  **CRAN R Packages**

    -   URL: <a href="https://cran.r-project.org/web/packages/" target="_blank" rel="noopener noreferrer">cran.r-project.org/web/packages</a>
    -   설명: R 패키지의 공식 리포지토리로, 현재 배포된 모든 패키지와 관련 문서를 제공합니다.

### C와 C++

1.  **R source**

    -   URL: <a href="https://github.com/wch/r-source/tree/trunk/src/main/" target="_blank" rel="noopener noreferrer">github.com/wch/r-source/tree/trunk/src/main</a>
    -   설명: 해당 Git repository를 통해 R의 기본적인 소스 구조를 이해할 수 있습니다. 개인적으로는 가장 많이 참고하는 자료입니다.<br><br>

2.  **R internals**

    -   URL: <a href="https://github.com/hadley/r-internals/" target="_blank" rel="noopener noreferrer">github.com/hadley/r-internals</a>
    -   설명: 해들리 위컴이 본인의 Git repository에서 R의 내부구조에 대해 설명한 자료입니다.<br><br>

3.  **R's C interface**

    -   URL: <a href="http://adv-r.had.co.nz/C-interface.html" target="_blank" rel="noopener noreferrer">adv-r.had.co.nz/C-interface.html</a>
    -   설명: 해들리 위컴의 Advanced R에서 C를 다룬 부분입니다.<br><br>

4.  **KIT**

    -   URL: <a href="https://teuder.github.io/rcpp4everyone_en/" target="_blank" rel="noopener noreferrer">teuder.github.io/rcpp4everyone_en</a>
    -   설명: Base R에서 제공되지 않은 것 포함 C로 구현된 기본 함수들의 소스 코드를 제공하고 있습니다. Base R 소스 코드보다 더 직관적인 느낌입니다.<br><br>

5.  **Rcpp**

    -   URL: <a href="https://rcpp.org/" target="_blank" rel="noopener noreferrer">rcpp.org</a>
    -   설명: C++ 코드와 R을 통합하여 R 패키지의 성능을 크게 향상시킬 수 있는 Rcpp 패키지에 대한 공식 사이트입니다. 다양한 예제와 가이드가 제공됩니다.<br><br>

6.  **Writing R Extensions**

    -   URL: <a href="https://cran.r-project.org/doc/manuals/r-release/R-exts.html" target="_blank" rel="noopener noreferrer">cran.r-project.org/doc/manuals/r-release/R-exts.html</a>
    -   설명: R 패키지에 C, C++ 코드와 연결하는 방법, R 인터페이스를 확장하는 방법 등을 포함한 공식 가이드입니다.<br><br>

7.  **Rcpp Gallery**

    -   URL: <a href="https://gallery.rcpp.org/" target="_blank" rel="noopener noreferrer">gallery.rcpp.org</a>
    -   설명: Rcpp를 활용한 다양한 예제와 코드 스니펫을 제공하여, R과 C++ 통합의 실전 활용 방법을 배울 수 있습니다.

### Shiny 모듈 개발

1.  **Mastering Shiny by Hadley Wickham**

    -   URL: <a href="https://mastering-shiny.org/" target="_blank" rel="noopener noreferrer">mastering-shiny.org</a>
    -   설명: Shiny 앱의 모듈화를 포함하여 Shiny 앱 개발을 심층적으로 다룬 가이드입니다. Shiny 모듈 개발에 필요한 구조와 패턴을 배울 수 있습니다.<br><br>

2.  **Shiny Modules Tutorial**

    -   URL: <a href="https://shiny.rstudio.com/articles/modules.html" target="_blank" rel="noopener noreferrer">shiny.rstudio.com/articles/modules.html</a>
    -   설명: Shiny 모듈을 사용하여 복잡한 앱을 더 쉽게 관리하고 재사용성을 높이는 방법을 설명하는 공식 튜토리얼입니다.<br><br>

3.  **Shiny Developer Series**

    -   URL: <a href="https://rstudio.github.io/shinydevseries/" target="_blank" rel="noopener noreferrer">rstudio.github.io/shinydevseries</a>
    -   설명: Shiny 앱 개발에 유용한 팁과 고급 기술을 다루며, 모듈화된 Shiny 앱 구축을 위한 가이드와 비디오를 제공합니다.<br><br>

### 테스트 및 CI/CD

1.  **usethis Package**

    -   URL: <a href="https://usethis.r-lib.org/" target="_blank" rel="noopener noreferrer">usethis.r-lib.org</a>
    -   설명: R 패키지 개발을 쉽게 만들어주는 usethis 패키지에 대한 문서입니다. 초기 설정부터 문서화, 테스트, 배포까지 자동화 도구를 제공합니다.<br><br>

2.  **testthat Package**

    -   URL: <a href="https://testthat.r-lib.org/" target="_blank" rel="noopener noreferrer">testthat.r-lib.org</a>
    -   설명: R의 가장 널리 사용되는 테스트 프레임워크로, 패키지 기능 테스트에 필수적입니다.<br><br>

3.  **GitHub Actions for R**

    -   URL: <a href="https://github.com/r-lib/actions" target="_blank" rel="noopener noreferrer">github.com/r-lib/actions</a>
    -   설명: R 패키지의 CI/CD 설정

### 기타

1.  **ChatGPT**

    -   URL: <a href="https://chatgpt.com/" target="_blank" rel="noopener noreferrer">chatgpt.com</a>
    -   설명: ChatGPT 만세!
