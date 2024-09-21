
# R 패키지 개발시 `ggplot2` 사용법

R 패키지 개발 시 `ggplot2`를 이용한 함수를 작성할 때, 우리는 먼저 `rlang` 패키지에 대해서 이해해야 합니다. `rlang` 패키지는 변수의 범위와 참조를 안전하게 관리할 수 있도록 돕는 중요한 도구입니다. 특히, `enquo()`, `enquos()`, `!!`, `!!!` 함수는 비표준 평가(Non-standard evaluation, NSE)를 안전하게 다룰 수 있게 해주어, `ggplot2`와 같은 그래픽 함수와의 통합을 쉽게 만듭니다. <br>
R을 활용하면서 기초함수에서 가장 빈번하게 나오는 비표준평가 예시는 `deparse(substitute(x))` 입니다. 하지만 이 표현을 재사용성을 위해 함수로 만들고 다른 함수안에서 사용하게 되면 그냥 x가 나오는 황당한 경험을 하게 됩니다. 그래서 이를 해결하기 위해 제가 아주 오래전 고안하게 된 표현은 다음과 같은 복잡한 형태였습니다.

``` r
f <- function(x) {
  print(deparse(substitute(x)))
}

# > f(t)
# [1] "t"

desub1 <- function(x) deparse(substitute(x))
f1 <- function(x) {
  print(desub1(x))
}

# > f1(t)
# [1] "x"

desub2 <- function(x) {
    deparse(eval(eval(eval(eval(eval(eval(eval(eval(eval(eval(eval(eval(eval(
    substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(substitute(x)))))))))))))), 
        envir = parent.frame(n = 1)), envir = parent.frame(n = 2)), 
        envir = parent.frame(n = 3)), envir = parent.frame(n = 4)), 
        envir = parent.frame(n = 5)), envir = parent.frame(n = 6)), 
        envir = parent.frame(n = 7)), envir = parent.frame(n = 8)), 
        envir = parent.frame(n = 9)), envir = parent.frame(n = 10)), 
        envir = parent.frame(n = 11)), envir = parent.frame(n = 12)), 
        envir = parent.frame(n = 13)))
}
f2 <- function(x) {
  print(desub2(x))
}

# > f2(t)
# [1] "t"
```
참고로 `desub2` 함수는 일반적인 R 환경에서는 잘 되지만, Shiny Application에서는 또다른 `namespace`를 고려해야 하므로 생각한대로 작동하지 않습니다. 그런 측면에서 `rlang`은 R 생태계에서 굉장히 훌륭한 대안으로서의 역할을 하게 된 것입니다.

## `rlang`의 역할

- **비반복 평가(NSE) 처리**: `ggplot2`와 같은 그래픽 패키지들은 변수 이름을 직접 인자로 받아 사용하는 비표준 평가 방식을 사용합니다. 이 때, `rlang` 패키지의 `enquo()`와 `enquos()`를 사용하여 함수 내에서 변수를 안전하게 참조하고, 코드가 의도한 대로 동작하도록 할 수 있습니다.
- **동적 변수 처리**: 사용자가 지정한 변수 이름을 함수 내에서 동적으로 인식하고 사용할 수 있게 해줍니다.
- **명확한 오류 처리**: 인자를 quosure로 변환하여, 변수의 유효성을 쉽게 검증할 수 있도록 돕습니다.

## `enquo()`와 `enquos()` 사용법

### 1. `enquo()`

`enquo()`는 단일 인자를 **quosure**로 변환하여 함수 내부에서 안전하게 참조할 수 있게 만듭니다. 이는 특히 `ggplot2`와 같은 함수 내에서 변수 이름을 다룰 때 유용합니다. 참고로 **quosure**는 코드 표현(expression)과 해당 코드가 평가될 환경(environment)을 묶어 놓은 객체입니다. 이를 통해 코드가 정의된 시점의 환경을 기억하여, 코드가 올바른 환경에서 평가될 수 있게 합니다.

#### 사용 예시

아래는 `enquo()`를 사용하여 `ggplot2`의 함수에서 동적으로 변수를 매핑하는 예시입니다.

```r
# 예제 함수: 단일 변수를 ggplot에서 사용
plot_single_variable <- function(data, x_var) {
  # 인자를 quosure로 변환
  x_var <- enquo(x_var)
  
  # ggplot2 사용 시 변수를 안전하게 매핑
  ggplot(data, aes(x = !!x_var)) +
    geom_histogram(binwidth = 1) +
    theme_minimal()
}

# 함수 사용 예시
library(ggplot2)
plot_single_variable(mtcars, mpg)
```

### 2. `enquos()`

`enquos()`는 여러 개의 인자를 받아 **quosure의 리스트**로 변환합니다. 이는 다수의 변수를 받아 처리할 때 유용하며, `ggplot2`에서 여러 변수를 동적으로 참조할 수 있게 합니다.

#### 사용 예시

아래는 `enquos()`를 사용하여 다수의 변수를 ggplot의 `aes()`에 동적으로 매핑하는 함수입니다.

```r
# 예제 함수: 여러 변수를 ggplot에서 사용
plot_multiple_variables <- function(data, ...) {
  # 인자를 quosure 리스트로 변환
  vars <- enquos(...)
  
  # 첫 번째 인자는 x 축, 두 번째 인자는 y 축으로 매핑
  ggplot(data, aes(!!vars[[1]], !!vars[[2]])) +
    geom_point() +
    theme_minimal()
}

# 함수 사용 예시
plot_multiple_variables(mtcars, mpg, wt)
```

### 3. `!!` (Bang-Bang 연산자)

- **역할**: `!!` 연산자는 quosure로 인용된 인자를 평가하여 실제 값으로 변환합니다. 이는 `ggplot2`와 같은 함수에서 변수를 동적으로 참조할 때 필요합니다.

### 4. `!!!` (Bang-Bang-Bang 연산자)

- **역할**: `!!!` 연산자는 여러 개의 인자나 리스트를 펼쳐서 함수에 전달할 때 사용됩니다. 주로 `enquos()`와 함께 사용되며, 여러 개의 quosure를 한 번에 풀어서 함수에 전달합니다.

#### 사용 예시

아래 예시는 `!!!` 연산자를 사용하여 `aes()` 함수에 여러 변수를 동적으로 전달하는 방법을 보여줍니다.

```r
# 예제 함수: 여러 변수를 ggplot에서 사용
plot_with_multiple_aes <- function(data, ...) {
  # 인자를 quosure 리스트로 변환
  vars <- enquos(...)
  
  # !!! 연산자를 사용하여 인자를 한 번에 펼쳐서 aes에 전달
  ggplot(data, aes(!!!vars)) +
    geom_point() +
    theme_minimal()
}

# 함수 사용 예시
plot_with_multiple_aes(mtcars, mpg, wt)
```
### 5. 요약

- `enquo()`: 단일 변수를 quosure로 변환하여 안전하게 참조.
- `enquos()`: 다수의 변수를 quosure 리스트로 변환하여 동적으로 매핑.
- `!!`: quosure를 평가하여 실제 값을 반환.
- `!!!`: 여러 quosure를 한 번에 풀어서 함수에 전달.

## 개발 예시
    -   `ggshort`: <a href="https://github.com/seokhoonj/ggshort/" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/ggshort/</a>

```r
library(ggplot2)
library(rlang)

ggbar <- function(data, x, y, ymin = NULL, ymax = NULL, ymin_err, ymax_err, 
    group = NULL, fill = NULL, text = NULL, bar_color = "transparent", 
    label, label_family = "Comic Sans MS", label_size = 4, label_angle = 0, 
    label_hjust = 0.5, label_vjust = 0.5, label_color = c("#000000", 
        "#FAF9F6")) {
    quo_maps <- rlang::enquos(x = x, y = y, ymin = ymin, ymax = ymax, 
        group = group, fill = fill, text = text)
    quo_maps <- quo_maps[!sapply(quo_maps, rlang::quo_is_null)]
    ggplot(data = data, aes(!!!quo_maps)) + geom_bar(stat = "identity", 
        position = position_dodge2(preserve = "single"), color = bar_color) + 
        list(if (!(missing(ymin_err) & missing(ymax_err))) {
            quo_errs <- rlang::enquos(x = x, ymin = ymin_err, 
                ymax = ymax_err)
            geom_errorbar(aes(!!!quo_errs), position = position_dodge2(preserve = "single"), 
                alpha = 0.5)
        }) + list(if (!missing(label)) {
        quo_lbl <- rlang::enquos(label = label)
        geom_text(aes(!!!quo_lbl), position = position_dodge2(width = 0.9, 
            preserve = "single"), family = label_family, size = label_size, 
            angle = label_angle, hjust = label_hjust, vjust = label_vjust, 
            color = label_color[1L])
    })
}

if (!require("insuranceData")) install.packages("insuranceData")

library(insuranceData)

data("AutoCollision")
head(AutoCollision)
#>   Age Vehicle_Use Severity Claim_Count
#> 1   A    Pleasure   250.48          21
#> 2   A  DriveShort   274.78          40
#> 3   A   DriveLong   244.52          23
#> 4   A    Business   797.80           5
#> 5   B    Pleasure   213.71          63
#> 6   B  DriveShort   298.60         171

ggbar(AutoCollision, x = Age, y = Claim_Count, fill = Vehicle_Use) + 
  labs(title = "Auto Collision") +
  theme_view()
```
![alt text](../images/ggbar-auto-collision.png){: width="70%"}

## 결론

`rlang` 패키지의 `enquo()`, `enquos()`, `!!`, `!!!`는 R 패키지 개발 시 `ggplot2`와의 통합을 매끄럽게 만들어줍니다. 이를 통해 사용자가 지정한 변수를 함수 내에서 동적으로 안전하게 처리할 수 있으며, 코드의 가독성과 유지보수성을 높일 수 있습니다.
