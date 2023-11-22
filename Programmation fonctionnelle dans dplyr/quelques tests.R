data(mtcars)

library(dplyr)
mtcars |> count(.data$mpg)


test1 <- function(data, x1){
data |> count({{x1}})
}

test2 <- function(data, x1){
  data |> count(.data[[x1]])
}

test3 <- function(data, ...){
  data |> count(...)
}

test1(mtcars, cyl)
test2(mtcars, "cyl")
test3(mtcars, cyl, mpg)


df <- data.frame(
  a1 = c(1,NA,2,NA),
  v_a1 = c(NA,0,NA,5),
  a2 = c(4,NA,8,NA),
  v_a2 = c(NA,7,NA,NA))

# Tests Louis ----

my_coalesce <- function(df,x){
  vx <- paste0("v_", x)
  return(coalesce(df[[x]], df[[vx]]))
}

df %>% mutate(across(c(a1, a2),
                     ~ my_coalesce(df=.data, x=cur_column())))

df %>% mutate(across(c(a1,a2),
                     ~ coalesce(.x, get(paste0(cur_column())))))


df |> mutate(across(c(a1, a2),
                    \(.) coalesce(., all_of(paste0("v_", cur_column)))))
