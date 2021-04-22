
# Fonction trouvée ici : 
# https://stats.stackexchange.com/questions/15011/generate-a-random-variable-with-a-defined-correlation-to-an-existing-variables/15035#15035
getBiCop <- function(n, rho, mar.fun=rnorm, x = NULL, ...) {
  if (!is.null(x)) {X1 <- x} else {X1 <- mar.fun(n, ...)}
  if (!is.null(x) & length(x) != n) warning("Variable x does not have the same length as n!")
  
  C <- matrix(rho, nrow = 2, ncol = 2)
  diag(C) <- 1
  
  C <- chol(C)
  
  X2 <- mar.fun(n)
  X <- cbind(X1,X2)
  
  # induce correlation (does not change X1)
  df <- X %*% C
  
  ## if desired: check results
  #all.equal(X1,X[,1])
  #cor(X)
  
  return(as.data.frame(df))
}

getBiCop(500, 0.6) -> df
library(ggplot2)
library(dplyr)
df %>% mutate(
  V2 = V2 + 3,
  V1 = (V1 + 3) * 1000,
  # utiliser alea2 pour montrer un échantillon biaisé
  alea = runif(500),
  alea2 = case_when(V2 <= 3 ~ alea,
                    TRUE ~ alea * 0.8),
  echantillon = case_when(alea > 0.8 ~ "Echantillon",
                          TRUE ~ "Reste de la population")
) %>% ggplot(aes(x = V1, y = V2, color = echantillon)) + 
  geom_point() + 
  labs(y = "Nombre d'années d'étude",
       x = "Revenu annuel",
       color = "") + 
  geom_smooth(method = "lm", se = FALSE)

summary(lm(V2 ~ V1, df))

sample(c(0,1), 2000, replace = TRUE)
?runif
