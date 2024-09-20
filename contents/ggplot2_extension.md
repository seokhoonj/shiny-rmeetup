
# R 패키지 개발 시 ggplot2 사용법

`ggplot2`는 R에서 가장 널리 사용되는 시각화 패키지 중 하나로, 복잡한 데이터를 간단하고 아름답게 시각화할 수 있도록 도와줍니다. R 패키지 개발 시 `ggplot2`를 활용하면 데이터 분석 결과를 시각적으로 명확하게 표현할 수 있으며, 여러 종류의 그래프를 생성할 수 있습니다.

## 1. `ggplot2` 설치 및 로드
```r
install.packages("ggplot2")
library(ggplot2)
```

## 2. `ggplot2`의 기본 구조
```r
ggplot(data = <데이터>, aes(x = <x축>, y = <y축>)) + geom_<형태>()
```

## 3. 주요 시각화 유형
- **산점도**: `geom_point()`
- **선 그래프**: `geom_line()`
- **막대 그래프**: `geom_bar()`
- **히스토그램**: `geom_histogram()`
- **박스 플롯**: `geom_boxplot()`

## 4. `ggplot2`의 세부 설정

### 색상, 크기, 모양 지정
```r
ggplot(data = mtcars, aes(x = wt, y = mpg, color = factor(cyl), size = hp)) +
  geom_point()
```

### 축과 제목 설정
```r
ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  labs(title = "산점도", x = "차량 무게", y = "연비")
```

### 테마 설정
```r
ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  theme_minimal()
```

### 범례 설정
```r
ggplot(data = mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point() +
  scale_color_manual(values = c("red", "blue", "green"), name = "실린더")
```

## 5. `ggplot2`를 사용한 R 패키지 개발

### 5.1 R 패키지에서 `ggplot2` 사용하기
R 패키지를 개발할 때 `ggplot2`를 사용하려면 `DESCRIPTION` 파일에 의존성을 추가합니다.
```r
# DESCRIPTION 파일에 의존성 추가
Imports:
  ggplot2
```

### 5.2 그래프 출력 파일 생성
```r
plot_mtcars <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

ggsave("mtcars_plot.png", plot = plot_mtcars)
```

## 6. 복잡한 시각화 생성

### 6.1 여러 개의 그래프 결합
```r
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  facet_wrap(~ cyl)
```

### 6.2 앤서블 그래프 (Annotated Graphs)
```r
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  annotate("text", x = 5, y = 30, label = "특이치", color = "red")
```

