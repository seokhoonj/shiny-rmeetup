
# `testthat` 패키지

`testthat`은 R 패키지 개발 중 테스트를 간편하게 작성하고 실행할 수 있도록 도와주는 패키지입니다. 패키지의 기능이 올바르게 작동하는지 확인하고, 코드 수정 후에도 동일한 결과를 유지하는지 보장하는 데 중요한 역할을 합니다. `testthat` 패키지는 특히 `devtools` 패키지와 함께 사용하면 편리합니다.

## `testthat` 패키지의 사용법

### 1. `testthat` 패키지 설치

먼저 `testthat` 패키지를 설치하고 로드해야 합니다.

```r
install.packages("testthat")
library(testthat)
```

### 2. 테스트 환경 설정

패키지 개발 시 `testthat`을 사용하여 테스트를 작성하려면 먼저 패키지 디렉토리에 `tests/` 디렉토리와 `testthat` 환경을 설정해야 합니다. 이를 위해 `devtools` 또는 `usethis` 패키지를 사용할 수 있습니다.

```r
# devtools 패키지를 사용하여 testthat 환경 설정
devtools::use_testthat()

# 또는 usethis 패키지를 사용할 수도 있습니다.
usethis::use_testthat()
```

이 명령어는 `tests/testthat/` 디렉토리를 생성하고, R CMD check에서 테스트가 실행되도록 설정합니다. `DESCRIPTION` 파일에도 `Suggests: testthat` 항목이 추가됩니다.

### 3. 테스트 파일 생성

테스트를 작성할 때는 함수별로 테스트 파일을 작성하는 것이 일반적입니다. `testthat`의 파일명 규칙에 따라 테스트 파일명은 `test-`로 시작해야 합니다.

```r
# devtools로 새로운 테스트 파일 생성
devtools::use_test("my_function")
```

위 명령어는 `tests/testthat/test-my_function.R` 파일을 생성합니다. 여기에서 `my_function()` 함수에 대한 테스트를 작성할 수 있습니다.

### 4. 테스트 작성

테스트 파일에서 `test_that()` 함수를 사용하여 테스트를 작성할 수 있습니다. 각 테스트는 하나의 논리적 단위를 담당하며, 기대하는 결과가 맞는지 확인합니다.

```r
# test-my_function.R 파일 예시
test_that("my_function works correctly", {
  result <- my_function(1, 2)
  expect_equal(result, 3)  # 기대 결과와 비교
})
```

- **`test_that()`**: 특정 테스트를 정의하는 함수입니다. 첫 번째 인수로는 테스트의 설명을, 두 번째 인수로는 테스트 코드 블록을 받습니다.
- **`expect_equal()`**: 기대한 값과 실제 값을 비교합니다. 두 값이 동일하면 테스트가 성공합니다.

### 5. 다양한 기대(expect) 함수

`testthat`은 여러 가지 `expect_*()` 함수를 제공하여 다양한 유형의 검증을 할 수 있습니다. 주요 함수들은 다음과 같습니다:

- **`expect_equal()`**: 두 값이 정확히 같은지 확인합니다.
- **`expect_identical()`**: 두 값이 완전히 동일한 객체인지 확인합니다.
- **`expect_true()`**: 표현식이 참인지 확인합니다.
- **`expect_false()`**: 표현식이 거짓인지 확인합니다.
- **`expect_error()`**: 특정 코드를 실행할 때 오류가 발생하는지 확인합니다.
- **`expect_warning()`**: 경고가 발생하는지 확인합니다.
- **`expect_message()`**: 특정 메시지가 출력되는지 확인합니다.

### 6. 테스트 실행

작성한 테스트를 실행하려면 다음 명령어를 사용할 수 있습니다:

```r
# 현재 패키지의 모든 테스트 실행
devtools::test()
```

이 명령어는 `tests/testthat/` 디렉토리에 있는 모든 테스트를 실행하고, 테스트 결과를 출력합니다. 테스트가 실패하면 실패한 이유를 출력해 줍니다.

### 7. 특정 파일에서 테스트 실행

특정 테스트 파일만 실행하려면 `test_file()`을 사용할 수 있습니다.

```r
testthat::test_file("tests/testthat/test-my_function.R")
```

이 명령어는 지정한 파일의 테스트만 실행합니다.

### 8. 테스트 스킵 및 조건부 테스트

때로는 테스트를 특정 조건에서만 실행하거나 스킵하고 싶을 수 있습니다. `skip_if()` 및 `skip()` 함수를 사용하여 이를 구현할 수 있습니다.

```r
test_that("condition-based test", {
  skip_if(Sys.info()["sysname"] != "Linux")  # OS가 Linux가 아니면 테스트 스킵
  result <- my_function(1, 2)
  expect_equal(result, 3)
})
```

- **`skip_if()`**: 특정 조건이 참일 때 테스트를 스킵합니다.
- **`skip()`**: 테스트를 강제로 스킵합니다.

### 9. 의사 난수 생성기 테스트

확률적 또는 난수 기반의 함수 테스트 시 일관된 결과를 얻기 위해 의사 난수 생성기를 고정할 수 있습니다.

```r
set.seed(123)
test_that("random function works consistently", {
  result <- my_random_function()
  expect_equal(result, expected_value)
})
```

`set.seed()`를 사용하여 난수 생성을 고정하면, 테스트 실행 시 일관된 결과를 얻을 수 있습니다.

### 10. 성능 테스트 (Benchmarking)

함수의 성능을 측정하고 싶다면 `bench` 패키지를 사용해 성능 테스트를 할 수 있습니다. `bench::mark()`를 사용하면 함수 실행 시간을 측정하고 성능 병목을 파악할 수 있습니다.

```r
library(bench)
bench::mark(my_function(1, 2))
```

### 11. 테스트의 자동화 (Continuous Integration)

`testthat` 테스트는 GitHub Actions와 같은 CI(Continuous Integration) 도구와 연동하여 코드 푸시마다 자동으로 실행되도록 설정할 수 있습니다. 이를 통해 코드가 항상 정상 작동하는지 확인할 수 있습니다.

```r
usethis::use_github_action("check-standard")
```

이 명령어는 GitHub Actions에 R CMD check와 함께 테스트가 자동으로 실행되도록 설정합니다.

## 요약

- **설치 및 설정**: `install.packages("testthat")`, `devtools::use_testthat()`
- **테스트 파일 생성**: `devtools::use_test("function_name")`
- **테스트 작성**: `test_that()`과 `expect_*()` 함수들을 사용하여 테스트 작성
- **테스트 실행**: `devtools::test()`를 사용해 패키지의 모든 테스트 실행
- **기타 기능**: 조건부 테스트 (`skip_if()`), 성능 테스트 (`bench::mark()`), 난수 고정 (`set.seed()`)

`testthat` 패키지는 R 패키지 개발 시 신뢰성과 안정성을 확보하는 데 매우 유용합니다. 테스트를 작성하고 주기적으로 실행함으로써 코드의 품질을 유지하고, 패키지의 기능이 의도대로 작동하는지 확실하게 검증할 수 있습니다.
