# R 패키지 개발시 C/C++ 사용법

# C 함수 사용

제가 사용하는 패키지 `jaid`의 일부를 활용해서 C 코드를 활용하여 성능을 최적화하는 방법에 대해 설명합니다. `jaid.h`, `init.c`, `matrix.c`, `group.c` 파일의 역할과 사용 방법에 대해 설명합니다.

## 목차

1.  jaid.h의 역할
2.  init.c의 역할
3.  matrix.c와 SumByColNames 함수
4.  matrix.R과 sum_by_colnames 함수
5.  ~~group.c와 IndexOverlappingDateRange 함수~~
6.  ~~overlap.R과 combine_overlapping_date_range 함수~~
7.  요약

## jaid.h의 역할

-   **jaid.h**는 C 코드에서 사용되는 함수의 선언을 포함하는 헤더 파일입니다.
-   다른 `.c` 파일들이 이 파일을 통해 함수들을 호출할 수 있게 합니다.
-   URL: <a href="https://github.com/seokhoonj/jaid/blob/main/src/jaid.h" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/jaid/blob/main/src/jaid.h</a>

``` c
// jaid.h
#ifndef JAID_H
#define JAID_H

// 함수 선언
// Group
SEXP IndexOverlappingDateRange(SEXP id, SEXP from, SEXP to, SEXP interval); // 함수의 프로토타입
// Matrix
SEXP SumByColNames(SEXP x, SEXP g, SEXP uniqueg, SEXP snarm); // 함수의 프로토타입

#endif // JAID_H
```

## init.c의 역할

-   **init.c**는 R과 C 함수를 연결하는 초기화 파일로, R에서 C 함수를 사용할 수 있도록 등록합니다.
-   `R_registerRoutines()` 함수를 사용하여 C 함수를 R 환경에 등록합니다.
-   URL: <a href="https://github.com/seokhoonj/jaid/blob/main/src/init.c" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/jaid/blob/main/src/init.c</a>

``` c
// init.c
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>
#include "jaid.h"

#define CALLDEF(name, n) {#name, (DL_FUNC) &name, n} // # is a stringify operator

static const R_CallMethodDef callEntries[] = {
  // Group
  CALLDEF(IndexOverlappingDateRange, 4),
  // Matrix
  CALLDEF(SumByColNames, 4),
  {NULL, NULL, 0}
};

void attribute_visible R_init_jaid(DllInfo *info) {
  R_registerRoutines(info, NULL, callEntries, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
  R_forceSymbols(info, TRUE);
}
```

## matrix.c의 SumByColNames 함수

-   **matrix.c** 파일은 행렬 연산을 수행하는 함수들을 구현합니다.
-   `SumByColNames` 함수는 주어진 행렬에서 특정 열 이름을 기준으로 합계를 계산합니다.
-   URL: <a href="https://github.com/seokhoonj/jaid/blob/main/src/matrix.c" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/jaid/blob/main/src/matrix.c</a>

``` c
// matrix.c
#include "jaid.h"

// 미리 정의 된 부분 (Hashing 관련)
...
...
...

// SumByColNames 함수 정의
SEXP SumByColNames(SEXP x, SEXP g, SEXP uniqueg, SEXP snarm) {
  SEXP matches, z;
  int n, p, ng, narm;
  HashData data = { 0 };
  data.nomatch = 0;

  n = LENGTH(g);
  ng = length(uniqueg);
  narm = asLogical(snarm);
  if (narm == NA_LOGICAL) error("'na.rm' must be TRUE or FALSE");
  if (isMatrix(x)) p = nrows(x); else p = 1;

  HashTableSetup(uniqueg, &data, NA_INTEGER); // 미리정의
  PROTECT(data.HashTable); // 미리 정의
  DoHashing(uniqueg, &data); // 미리 정의
  PROTECT(matches = HashLookup(uniqueg, g, &data)); // 미리 정의
  int *pmatches = INTEGER(matches);

  PROTECT(z = allocMatrix(TYPEOF(x), p, ng));

  switch(TYPEOF(x)){
  case INTSXP:{
    Memzero(INTEGER(z), p*ng);
    int* iz = INTEGER(z);
    int* ix = INTEGER(x);
    for (int i = 0; i < n; i++) {
      int colz = (pmatches[i] - 1) * p;
      int colx = i*p;
      for (int j = 0; j < p; j++) {
        iz[colz + j] += ix[colx + j];
      }
    }
  } break;
  case REALSXP:{
    Memzero(REAL(z), p*ng);
    double* iz = REAL(z);
    double* ix = REAL(x);
    for (int i = 0; i < n; i++) {
      int colz = (pmatches[i] - 1) * p;
      int colx = i*p;
      for (int j = 0; j < p; j++) {
        iz[colz + j] += ix[colx + j];
      }
    }
  } break;
  default:
    error("non-numeric matrix in row_sum_by_cn(): this should not happen");
  }
  if (TYPEOF(uniqueg) != STRSXP) error("row names are not character");
  SEXP dn = allocVector(VECSXP, 2), dn2, dn3;
  setAttrib(z, R_DimNamesSymbol, dn);
  SET_VECTOR_ELT(dn, 1, uniqueg);
  dn2 = getAttrib(x, R_DimNamesSymbol);
  if (length(dn2) >= 2 && !isNull(dn3 = VECTOR_ELT(dn2, 0)))
    SET_VECTOR_ELT(dn, 0, dn3);
  UNPROTECT(3); /* HashTable, matches, z */
  return z;
}
```

## matrix.R과 `sum_by_colnames` 함수

-   `SumByColNames` C 함수를 `sum_by_colnames` 라는 R 함수로 호출합니다.
-   URL: <a href="https://github.com/seokhoonj/jaid/blob/main/R/matrix.R" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/jaid/blob/main/src/matrix.R</a>

``` r
# matrix.R

sum_by_colnames <- function(x, na.rm = TRUE) {
  g <- colnames(x); uniqueg <- unique(g)
  .Call(SumByColNames, x, g, uniqueg, na.rm)
}
```

## ~~group.c의 `IndexOverlappingDateRange` 함수~~

-   **group.c**는 날짜 범위가 겹치는 인덱스를 찾는 `IndexOverlappingDateRange` 함수를 제공합니다.
-   이 함수는 시간 범위의 오류가 있는 데이터에서 중복을 제거하는데 유용합니다.

``` c
// group.c

#include "jaid.h"

/* "loc" means numbers to be grouped. if the loc vector is like
 * c(1, 1, 1, 2, 2, 2, 2), we got two groups first 3 rows and second 4 rows.
 * "sub" means subtracting number of days when the interval argument is longer
 * than 0. if the two date ranges are like "2014-02-03 ~ 2014-02-04" and
 * "2014-02-12 ~ 2014-02-13" and the interval is 7, it is combined as 2014-02-03 ~ 2014-02-13 */
SEXP IndexOverlappingDateRange(SEXP id, SEXP from, SEXP to, SEXP interval) {
  R_xlen_t m, n, i, j;
  SEXP loc, sub, v, z;
  if (isVectorList(id)) {
    m = XLENGTH(VECTOR_ELT(id, 0)), n = XLENGTH(id);
  } else {
    m = XLENGTH(id), n = 1;
  }

  // type of date is double
  double *ifr = REAL(from);
  double *ito = REAL(to);
  // interval is integer
  double vinterval = asReal(interval);

  PROTECT(loc = allocVector(INTSXP, m));
  PROTECT(sub = allocVector(INTSXP, m));
  FillCInt(loc, 1);
  FillCInt(sub, 0);
  int *iloc = INTEGER(loc);
  int *isub = INTEGER(sub);

  int p = 1, mx = 0; // index, maximum `to`
  bool c1, c2; // condition 1, condition 2
  for (i = 1; i < m; ++i) {
    j = 0, c1 = true;
    while (j < n) {
      if (isVectorList(id)) {
        v = VECTOR_ELT(id, j);
      } else {
        v = id;
      }
      switch(TYPEOF(v)){
      case LGLSXP:{
        int *iv = LOGICAL(v);
        c1 = (iv[i-1] == iv[i]);
      } break;
      case INTSXP:{
        int *iv = INTEGER(v);
        c1 = (iv[i-1] == iv[i]);
      } break;
      case REALSXP:{
        double *iv = REAL(v);
        c1 = (iv[i-1] == iv[i]);
      } break;
      case STRSXP:{
        SEXP *iv = STRING_PTR(v);
        c1 = (!strcmp(CHAR(iv[i-1]), CHAR(iv[i])));
      } break;
      default:
        error(_("invalid input"));
      }
      if (c1 == false) break;
      j++;
    }
    mx = (ito[i-1] > mx) ? ito[i-1] : mx;
    c2 = ifr[i] <= (mx + 1 + vinterval);
    if (c1 && c2) {
      iloc[i] = p;
      if (ifr[i] > mx) isub[i] = ifr[i] - mx - 1;
    } else {
      iloc[i] = ++p;
      mx = ito[i];
    }
  }
  const char *names[] = {"loc", "sub", ""};
  PROTECT(z = mkNamed(VECSXP, names));
  SET_VECTOR_ELT(z, 0, loc);
  SET_VECTOR_ELT(z, 1, sub);
  UNPROTECT(3);
  return z;
}
```

### ~~overlap.R과 `combine_overlapping_date_range` 함수~~

-   `IndexOverlappingDateRange` C 함수를 `combine_overlapping_date_range`라는 R 함수로 호출합니다.
-   URL: <a href="https://github.com/seokhoonj/jaid/blob/main/R/overlap.R" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/jaid/blob/main/src/overlap.R</a>

``` r
# overlap.R

combine_overlapping_date_range <- function(df, id_var, merge_var, from_var, to_var,
                                           interval = 0, collapse = "|") {
  id_var    <- match_cols(df, sapply(rlang::enexpr(id_var), rlang::as_name))
  merge_var <- match_cols(df, sapply(rlang::enexpr(merge_var), rlang::as_name))
  from_var  <- rlang::as_name(rlang::enquo(from_var))
  to_var    <- rlang::as_name(rlang::enquo(to_var))
  all_var   <- c(id_var, merge_var, from_var, to_var)
  dt <- df[, .SD, .SDcols = all_var]
  data.table::setnames(dt, c(id_var, merge_var, "from", "to"))
  data.table::setorderv(dt, c(id_var, "from", "to"))
  data.table::set(dt, j = "sub_stay", value = 0)
  index <- .Call(IndexOverlappingDateRange, dt[, .SD, .SDcols = id_var],
                 dt$from, dt$to, interval = interval) // C 함수 호출
  data.table::set(dt, j = "loc", value = index$loc) # group index to combine
  data.table::set(dt, j = "sub", value = index$sub) # days to subtract, if the interval is longer than 0
  group_var <- c(id_var, "loc")
  m <- dt[, lapply(.SD, function(x) paste(unique(x[!is.na(x)]), collapse = collapse)),
          keyby = group_var, .SDcols = merge_var]
  from <- to <- sub_stay <- sub <- NULL
  s <- dt[, list(from = min(from), to = max(to), sub_stay = sum(sub_stay) + sum(sub)),
          keyby = group_var]
  z <- m[s, on = group_var]
  data.table::set(z, j = "loc", value = NULL)
  data.table::set(z, j = "stay", value = as.numeric(z$to - z$from + 1 - z$sub_stay))
  data.table::set(z, j = "sub_stay", value = NULL)
  data.table::setnames(z, c(all_var, "stay"))
  return(z)
}
```

## 요약

C 코드는 R의 성능을 극대화합니다. `jaid.h`, `init.c`, `functions.c`, `functions.R` 파일을 통해 R과 C 간의 상호작용을 효과적으로 구현할 수 있습니다. 참고로, `sum_by_colnames`와 같은 기능을 하는 기초함수가 없고, `combine_overlapping_date_range`와 같은 기능을 R로 구현하면 데이터의 크기에 따라 엄청난 속도 차이를 보이게 됩니다. 

# C++ 사용

이 문서는 R 패키지에서 C++ 코드를 활용하여 성능을 최적화하는 방법에 대해 설명합니다. `RcppExports.cpp`와 `add.cpp` 파일의 역할, 그리고 `cppAdd` 함수가 R과 어떻게 연결되는지를 다룹니다.

## 목차

1.  RcppExports.cpp의 역할
2.  add.cpp와 cppAdd 함수
3.  R에서 cppAdd 함수 호출
4.  Makevars 파일
5.  요약

## RcppExports.cpp의 역할

-   **자동 생성 파일**: `RcppExports.cpp`는 `Rcpp` 패키지가 자동으로 생성하는 파일로, C++ 함수와 R 간의 인터페이스를 설정합니다.
-   **Rcpp Attributes 사용**: `Rcpp`는 함수 위에 `// [[Rcpp::export]]`와 같은 주석을 통해 R과 C++ 간의 연결을 설정합니다. 이 주석을 통해 `Rcpp`는 C++ 함수를 R에서 호출할 수 있도록 필요한 코드를 자동으로 생성합니다.
-   **함수 등록 및 매핑**: `RcppExports.cpp`는 패키지 초기화 시 `init.c`와 유사하게 C++ 함수가 R에서 호출될 수 있도록 등록합니다.

### RcppExports.cpp의 예시

``` cpp
// RcppExports.cpp
#include <Rcpp.h>
using namespace Rcpp;

// cppAdd를 포함한 C++ 함수가 이 파일에서 정의되어 R과 연결됨

// Rcpp::export 주석을 사용해 자동으로 R과 C++ 함수 연결을 설정
// [[Rcpp::export]]
int cppAdd(int x, int y) {
    // C++ 구현부는 add.cpp에서 정의된 함수 호출
    return cppAdd_internal(x, y);
}
```

## add.cpp와 cppAdd 함수

-   **간단한 예제**: `add.cpp`는 R의 기본 함수보다 빠른 속도를 제공하는 C++ 함수들을 구현하는 파일입니다. 특히, `cppAdd` 함수는 두 정수를 더하는 간단한 기능을 제공합니다.
-   **내부 구현**: `cppAdd`는 실제 계산을 수행하는 함수로, 간단한 덧셈 작업을 수행합니다.

### add.cpp에서 cppAdd의 구현 예시

``` cpp
// cppAdd.cpp
#include <Rcpp.h>
using namespace Rcpp;

// cppAdd 함수의 실제 구현
int cppAdd(int x, int y) {
    // 두 수를 더하여 반환
    return x + y;
}
```

## R에서 cppAdd 함수 호출

R에서는 `Rcpp`가 생성한 `RcppExports.cpp` 덕분에 C++ 함수 `cppAdd`를 간단하게 호출할 수 있습니다.

``` r
# R에서 C++ 함수 호출 예시
library(jaid)

# 두 숫자를 더하기
result <- cppAdd(3, 4)
print(result)  # 출력: 7
```

## Makevars 파일

-   **Makevars**는 C/C++ 코드의 컴파일을 제어하는 설정 파일입니다.

### Makevars 예시

``` makefile
# Makevars
# R 3.1.0 이상에서 C++11을 사용하도록 설정
CXX_STD = CXX11

# OpenMP 지원 플래그
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS)

# 사용하는 라이브러리 설정
PKG_LIBS = $(SHLIB_OPENMP_CXXFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
```

## 요약

1.  **`RcppExports.cpp`**: `Rcpp`에 의해 자동으로 생성되어 C++ 함수와 R 간의 연결을 설정합니다. 이 파일은 `Rcpp::export` 주석을 기반으로 R과 C++ 함수 간의 매핑을 설정합니다.
2.  **`add.cpp`의 `cppAdd` 함수**: C++로 간단한 덧셈을 수행하는 함수로, R의 기본 계산 함수보다 빠르게 동작하도록 설계되었습니다.
3.  **R과의 통합**: `Rcpp` 덕분에 R 사용자들은 C++로 작성된 고성능 함수를 손쉽게 사용할 수 있으며, 데이터 처리 속도를 대폭 향상시킬 수 있습니다.
