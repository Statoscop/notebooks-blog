---
title: "Programmation fonctionnelle dans dplyr"
author: "Antoine"
date: ""
output: 
  html_document:
    keep_md: true
---



# Le tidyverse et l'évaluation non standard  

La syntaxe du `tidyverse` s'appuie sur des fonctions aux noms explicites et une grande facilité d'utilisation. Le principe est de rendre le code le plus lisible possible. Tout cela permet de coder de manière intuitive et peu verbeuse. Mais lorsqu'il s'agit de coder ses propres fonctions, les choses se compliquent. Prenons par exemple la fonction suivante, qui permet de donner le nombre d'observations d'un dataframe dont une valeur numérique est inférieure à un certain seuil :  


```r
library(dplyr)
## 
## Attachement du package : 'dplyr'
## Les objets suivants sont masqués depuis 'package:stats':
## 
##     filter, lag
## Les objets suivants sont masqués depuis 'package:base':
## 
##     intersect, setdiff, setequal, union

my_filter <- function(data, x1, seuil){
  data |> filter(x1 <= seuil) |> nrow()
}
```

L'appel de cette fonction pour obtenir le nombre de voitures avec `mpg <= 20` donne l'erreur suivante:  


```r
data(mtcars)

my_filter(mtcars, x1 = mpg, seuil = 20)
## Error in `filter()`:
## ! Problem while computing `..1 = x1 <= seuil`.
## Caused by error in `mask$eval_all_filter()`:
## ! objet 'mpg' introuvable
```

Cette erreur est la conséquence d'une propriété importante du `tidyverse` : le __data masking__. C'est cette propriété qui fait que les verbes de dplyr évaluent l'appel d'une fonction à un objet au sein du dataframe auquel elle s'applique. Ainsi, on fait appel à des fonctions avec la syntaxe `fonction(data, var1, var2, var3)` et non `fonction(data$var1, data$var2, data$var3)`. Couplé à l'utilisation du _pipe_ (que ce soit le `%>%` de `magritr` ou le récent `|>` de R auquel nous commençons à nous convertir), cette fonctionnalité permet d'obtenir un code bien plus aisé et agréable à écrire et à lire. Ainsi, dans `dplyr`, on considère un peu __le dataframe comme un environnement__ et les colonnes de ce dataframe comme des éléments de cet environnement. 

Seulement voilà, cette évaluation n'est pas non-standard pour rien : ici lors de l'appel de `my_filter` l'objet `mpg` est cherché dans l'environnement et il n'est pas trouvé. Et pour cause : il n'existe pas, contrairement à `mtcars$mpg`. 

# Faire référence aux paramètres de ma fonction   

Comment donc coder comme un développeur de Posit et profiter de cette syntaxe avantageuse? Si les choses ne sont pas aussi simples et intuitives qu'avec base R, elles se sont récemment simplifiées et ne devraient pas vous poser trop de problèmes.  

## Paramètres renseignés en symboles  

Si les paramètres sont renseignés "en dur", ou en symboles, comme c'est le cas dans les verbes de `dplyr`, on privilégiera l'écriture `{{ var }}`. Elle s'est récemment substituée à l'ancienne option, plus énigmatique, de `!!enquo(var)`.   
Testons cela sur notre petite fonction :  

```r
my_filter <- function(data, x1, seuil){
  data |> filter({{ x1 }} <= seuil) |> nrow()
}
my_filter(mtcars, x1 = mpg, seuil = 20)
## [1] 18
```
Merveilleux! Mais si, pour une raison ou pour une autre, vous souhaiteriez que l'utilisateur de votre fonction entre le paramètre sous forme de chaîne de caractère?

## Paramètres renseignés en chaînes de caractères  
Dans ce cas, on revient à une notation classique de base R : `df[["var"]]`. Sauf que, dans un contexte d'expressions chaînées, on va utiliser la notation bien utile `.data[["var"]]` qui fait référence au dataframe de la chaîne d'expression _dans son état au moment de l'appel__. En effet, si je voulais faire référence au dataframe par son nom je pourrais me retrouver dans cette situation :  


```r
mtcars |> filter(mpg < 20) |> transmute(carb_2 = mtcars[["carb"]]^2) |> head(1)
## Error in `transmute()`:
## ! Problem while computing `carb_2 = mtcars[["carb"]]^2`.
## ✖ `carb_2` must be size 18 or 1, not 32.
```
Les tailles des vecteurs ne correspondent pas! En effet, le filtre appliqué n'est pas pris en compte au moment de l'appel à la variable `carb`. La notation `.data` résoud bien ce souci :  

```r
mtcars |> filter(mpg < 20) |> transmute(carb_2 = .data[["carb"]]^2) |> head(1)
##                   carb_2
## Hornet Sportabout      4
```

Pour en revenir à notre fonction, il est donc très aisé avec cette notation de définir le paramètre en chaîne de caractères :  


```r
my_filter <- function(data, x1, seuil){
  data |> filter(.data[[x1]] <= seuil) |> nrow()
}
my_filter(mtcars, x1 = "mpg", seuil = 20)
## [1] 18
```
Mais si vous préférez l'ancienne notation, c'est la suivante et elle marche encore :  

```r
my_filter <- function(data, x1, seuil){
  data |> filter(!!sym(x1) <= seuil) |> nrow()
}
my_filter(mtcars, x1 = "mpg", seuil = 20)
## [1] 18
```

## Nommer des variables en fonction des paramètres  
Imaginons maintenant que nous voulions créer une indicatrice en fonction du seuil d'une variable numérique, et que nous aimerions nommer cette indicatrice en fonction de la variable numérique qu'elle décrit :  


```r
my_indic <- function(data, x1, seuil){
  data |> mutate(x1_indic = if_else({{ x1 }} <= seuil, 1, 0))
}
```

Dans cette version ma nouvelle variable va s'appeler `x1_indic`, et non prendre le nom de la variable numérique de `x1`. Et là encore c'est la double accolade qui va nous permettre de résoudre ce problème, mais pas seulement. Pour cela, on fait référence au nom du paramètre au sein d'une double accolade. De plus, le nom de la variable ainsi créée est donné entre guillemets. On peut également ajouter d'autres caractères. Enfin, __le signe `=` doit être remplacé par `:=`__. Cela donne :  


```r
my_indic <- function(data, x1, seuil){
  data |> mutate("{{ x1 }}_indic" := if_else({{ x1 }} <= seuil, 1, 0))
}
```

On vérifie avec `mpg` que la variable `mpg_indic` est bien créé :  


```r
my_indic(mtcars, mpg, seuil = 20) |> count(mpg_indic)
##   mpg_indic  n
## 1         0 14
## 2         1 18
```

# Coder une fonction avec n'importe quel nombre de paramètres  
Essayons maintenant d'aller un peu plus loin! 
## Paramètres renseignés en symboles  

`...` 

## Paramètres renseignés en chaînes de caractères  
all_of, any_of dans vecteur de chaînes de caractères  

## Utiliser la souplesse du tidyselect combiné avec across   
where, ends_with, starts_with...
argument .names de across  

# Références  

[Programming with dplyr](https://dplyr.tidyverse.org/articles/programming.html#user-supplied-data)
[Name injection - rlang](https://rlang.r-lib.org/reference/glue-operators.html)
[Data mask programming patterns](https://rlang.r-lib.org/reference/topic-data-mask-programming.html)
