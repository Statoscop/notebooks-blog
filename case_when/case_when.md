---
title: "Utilisation de case_when dans dplyr : cas des variables facteurs"
author: "Antoine"
date: "??/??/????"
output: 
  html_document:
    toc: true
    keep_md: true
---




Le verbe `case_when` est un incontournable du traitement de données avec `dplyr`. Il permet de créer une variable conditionnellement à une ou plusieurs variables existantes. Sa syntaxe est très lisible et permet à votre code de rester clair. Cependant, vous avez peut-être déjà eu quelques problèmes à l'utiliser avec des variables facteurs. Dans cette note, on vous présente ce verbe bien pratique de `dplyr`, ses nouveautés et comment l'utiliser pour créer directement des variables facteurs. 

# Syntaxe de case_when dans dplyr et différences avec if_else   

Pour cet article, nous nous reposons sur un dataset complètement fictif qui a la structure suivante :  


```
## tibble [200 × 4] (S3: tbl_df/tbl/data.frame)
##  $ id    : int [1:200] 1 2 3 4 5 6 7 8 9 10 ...
##  $ groupe: chr [1:200] "C" "C" "C" "B" ...
##  $ valeur: int [1:200] NA 20 10 28 19 30 NA 22 20 20 ...
##  $ statut: Factor w/ 2 levels "ko","ok": NA 1 NA 1 1 2 1 NA 2 2 ...
```

Vous pouvez retrouver le code ayant servi à le générer sur [le dépôt des notes de blog de Statoscop](https://github.com/Statoscop/notebooks-blog).  

Le verbe `case_when` comporte plusieurs différences avec `if_else`, mais deux nous semblent particulièrement importantes :   


- sa syntaxe rend la lecture de plusieurs conditions bien plus aisée    
- par défaut, il ne renvoie pas NA s'il croise une valeur manquante dans la condition  

Pour __la première différence__, la syntaxe de `case_when` va permettre de définir les différentes conditions et la valeur associée chacune sur une ligne alors que celle de `if_else` oblige à chaîner les appels à la fonction. Illustrons cela en codant des deux manières une variable égale à :  

- "cas 1" si groupe = "A" et valeur < 25 
- "cas 2" si groupe = "B" ou "C" et valeur >= 25 
- "cas 3" sinon

Le code avec les deux syntaxes est le suivant :  


```r
df <- df |> mutate(
  
  # syntaxe case_when
  cond_case = case_when(
    groupe == "A" & valeur < 25 ~ "cas 1",
    groupe %in% c("B", "C") & valeur >= 25 ~ "cas 2",
    .default = "cas 3"),
  
  # syntaxe if_else
  cond_ifelse = if_else(
    groupe == "A" & valeur < 25,
    "cas 1",
    if_else(
      groupe %in% c("B", "C") & valeur >= 25,
      "cas 2",
      "cas 3"))
  ) 
```

Pour __la seconde différence__, `case_when` considère les valeurs manquantes comme une valeur à part entière alors que `if_else` renvoie automatiquement une valeur manquante s'il trouve une valeur manquante dans la condition. Si l'on observe nos deux variables on constate en effet qu'elles ne sont pas toujours égales :  


```r
df |> head(10)
```

```
## # A tibble: 10 × 6
##       id groupe valeur statut cond_case cond_ifelse
##    <int> <chr>   <int> <fct>  <chr>     <chr>      
##  1     1 C          NA <NA>   cas 3     <NA>       
##  2     2 C          20 ko     cas 3     cas 3      
##  3     3 C          10 <NA>   cas 3     cas 3      
##  4     4 B          28 ko     cas 2     cas 2      
##  5     5 C          19 ko     cas 3     cas 3      
##  6     6 B          30 ok     cas 2     cas 2      
##  7     7 B          NA ko     cas 3     <NA>       
##  8     8 B          22 <NA>   cas 3     cas 3      
##  9     9 C          20 ok     cas 3     cas 3      
## 10    10 A          20 ok     cas 1     cas 1
```
Ainsi, __lorsque la valeur de la variable `valeur` est manquante__, la méthode `if_else` renvoie une valeur manquante alors que `case_when` lui donne la valeur "cas 3" car elle ne correspond pas aux deux premières conditions. Il faut donc __traiter explicitement les valeurs manquantes dans les conditions de `case_when` si l'on souhaite qu'elles ne soient pas prises en compte__.  



# Gestion des types facteur avec case_when   



```r
df |> mutate(
  test = case_when(
    !is.na(valeur) ~ as.numeric(valeur < 20),
    is.na(valeur) ~ "Manquant",
    .ptype = character()
  )
)
```

```
## Error in `mutate()`:
## ℹ In argument: `test = case_when(...)`.
## Caused by error in `case_when()`:
## ! Can't convert `..1 (right)` <double> to <character>.
```


les différentes valeurs définies doivent être du même type
parler de la maj qui a harmonisé tout ça
Seee [les news de dplyr](https://cran.r-project.org/web/packages/dplyr/news/news.html)  


## `.ptype` pour créer directement un facteur 



## `.default` pour définir la valeur de base  

TRUE ~ ou .default? -> cas quand le défaut est justement une variable facteur
