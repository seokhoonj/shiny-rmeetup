# R 패키지 개발시 Python 사용법

R 패키지 개발 시 Python의 **클래스**를 활용하여 기능을 구현하고, 이를 R과 통합할 수 있습니다. 이는 R이 기본적으로 제공하는 기능의 확장을 가능하게 하며, 특히 복잡한 알고리즘이나 데이터 처리 작업을 파이썬으로 구현하고, 이를 R에서 쉽게 사용할 수 있도록 합니다. 여기서는 `papagor` 패키지를 참고하여, R 패키지에서 파이썬 클래스를 사용하는 방법을 설명합니다.
    -   `papagor`: <a href="https://github.com/seokhoonj/papagor/" target="_blank" rel="noopener noreferrer">github.com/seokhoonj/papagor/</a>
    
## 1. R과 Python 통합을 위한 `reticulate` 패키지

`reticulate`는 R과 Python을 통합하는 R 패키지로, Python의 객체를 R에서 직접 사용할 수 있게 합니다. `reticulate`를 사용하면 Python에서 정의한 클래스와 메서드를 R 환경 내에서 호출하고 조작할 수 있습니다.

## 2. Python 클래스 작성

`papagor` 패키지에서 사용할 Python 클래스를 작성합니다. 

``` python
# translator.py

# NAVER Papago Text Translation API
import urllib.request
import json
import numpy as np
import pandas as pd
from numbers import Number

class Translator:
    '''papago translator'''
    def __init__(self, client_id, client_secret, source, target, platform = False):
        self.client_id = client_id
        self.client_secret = client_secret
        self.source = source
        self.target = target
        self.platform = platform

    def translate_text(self, text):
        '''simple translator'''
        ...
        return translated_text
        
    def translate(self, text):
        '''generalized translator'''
        ...
        return translated
        
    ...
```
이 Python 파일을 `papagor/inst/python/papago/translator.py`로 저장합니다. 그리고 최종적으로는 다음과 같은 구조를 갖게 됩니다.

![alt text](../images/papagor_tree.png){: width="70%"}

## Python 클래스를 활용할 R 함수 작성

``` r
# translate.R

translate <- function(text, source, target, platform = TRUE) {
  client_id <- get_client_id()
  client_secret <- get_client_secret()
  if (missing(source))
    source <- get_source_lang()
  if (missing(target))
    target <- get_target_lang()
  translator <- papago$translator$Translator(
    client_id = client_id,
    client_secret = client_secret,
    source = source,
    target = target,
    platform = platform
  )
  return(translator$translate(texts = text))
}
```

## `papagor` 패키지 로드 시 Python 클래스를 불러올 코드 작성

``` r
# zzz.R

papago <- NULL
.onLoad <- function(libname, pkgname) {
  papago <<- reticulate::import_from_path(
    module = "papago",
    path = system.file("python", package = "papagor"),
    delay_load = TRUE
  )
}
```

실제로 `papagor`을 로드하면 다음과 같이 `papago` 클래스에 접근할 수 있습니다.

``` r
> library(papagor)
# Please register your app and get your client id and secret from website 'https://developers.naver.com/apps/#/register'.

> papagor:::papago
# Module(papago) # module

> papagor:::papago$translator
# Module(papago.translator) # module

> papagor:::papago$translator$Translator
# <class 'papago.translator.Translator'> # class

> papagor:::papago$translator$Translator$translate
# <function Translator.translate at 0x000000000000> # function
```

이제 다음과 같이 R에서 Python 클래스를 이용한 함수를 사용할 수 있게 됩니다.

``` r
papagor::set_lang_env(source = "en", target = "ko")
papagor::translate("Hello")
# > 안녕하세요
```
