library(ggplot2)
library(patchwork)
library(dplyr)

poly1 <- 10
poly2 <- 2

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

set.seed(2)
n <- 1000
getBiCop(n, 0.7) %>% mutate(
  V1 = (V1 + 3),
  V2 = (V2 + 3) * 10,
  # utiliser alea2 pour montrer un échantillon biaisé
  alea = runif(n),
  echantillon = case_when(alea > 0.95 | V1 == min(V1) | V1 == max(V1) ~ "Echantillon",
                          TRUE ~ "Pop. tot.")) -> df 

# partie biais
# df %>% ggplot() + 
#   geom_point(aes(x = V1, y = V2, color = echantillon_biais), size=0.2) + 
#   labs(x = "X",
#        y = "Y",
#        color = "") + 
#   xlim(0, 40) + ylim(0, 7000) + 
#   geom_smooth(aes(x = V1, y = V2, color = echantillon_biais), method = "lm", se = FALSE) -> plot_df

# summary(lm(V2 ~ V1, df))

# partie variance
summary(df$alea)
df_echant <- df %>% filter(echantillon == "Echantillon")
df_echant$pred_0 <- mean(df_echant$V2)

mod_1 <- lm(V2~V1, data=df_echant)
r2_1 <- summary(mod_1)$r.squared
df_echant$pred_1 <- predict(mod_1, df_echant)


mod_2 <- lm(V2~poly(V1, poly1), data=df_echant)
r2_2 <- summary(mod_2)$r.squared
df_echant$pred_2 <- predict(mod_2, df_echant)
df_echant_pred <- data.frame(V1 = seq(min(df$V1),max(df$V1), by = 0.01))
df_echant_pred$pred_2 <- predict(mod_2, df_echant_pred)


mod_3 <- lm(V2~poly(V1, poly2), data=df_echant)
r2_3 <- summary(mod_3)$r.squared
df_echant$pred_3 <- predict(mod_3, df_echant)
df_echant_pred$pred_3 <- predict(mod_3, df_echant_pred)

df_echant %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2)) + 
  geom_line(aes(x = V1, y = pred_0), color = "red") +
  geom_point(aes(x = V1, y = pred_0), color = "green4") +
  labs(x = "X",
       y = "Y",
       title = paste0("M1 - R2 : 0%")) +
  theme_bw()  -> plot_0

df_echant %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2)) + 
  geom_line(aes(x = V1, y = pred_1), color = "red") +
  geom_point(aes(x = V1, y = pred_1), color = "green4") +
  labs(x = "X",
       y = "Y",
       title = paste0("M2 - R2 : ", round(r2_1, 2)*100, "%")) +
  theme_bw()  -> plot_1
  
df_echant %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2)) + 
  geom_line(data=df_echant_pred, aes(x = V1, y = pred_2), color = "red") +
  geom_point(aes(x = V1, y = pred_2), color = "green4") +
  labs(x = "X",
       y = "Y",
       title = paste0("M3 - R2 : ", round(r2_2, 2)*100, "%")) +
  theme_bw() -> plot_2


plot_0 + plot_1  + plot_2

# partie arbitrage biais variance ----

MSE <- function(fitted, true){
  mean((fitted - true)^2)
}

df$pred_0 <- mean(df$V2)
r2b_0 <- MSE(df$pred_0, df$V2)

df$pred_1 <- predict(mod_1, df)
r2b_1 <- MSE(df$pred_1, df$V2)

df$pred_2 <- predict(mod_2, df)
r2b_2 <- MSE(df$pred_2, df$V2)

df$pred_3 <- predict(mod_3, df)
r2b_3 <- MSE(df$pred_3, df$V2)

df %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2, color = echantillon)) + 
  scale_color_manual(values=c("black", "grey85")) +
  geom_line(aes(x = V1, y = pred_0), color = "red") +
  geom_point(aes(x = V1, y = pred_0), color = "green4") +
  labs(x = "X",
       y = "Y",
       color ="",
       title = paste0("M1 - MSE : ", round(r2b_0, 0))) +
  guides(color=FALSE) +
  theme_bw() -> plotb_0

df %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2, color = echantillon)) + 
  scale_color_manual(values=c("black", "grey85")) +
  geom_line(aes(x = V1, y = pred_1), color = "red") +
  geom_point(aes(x = V1, y = pred_1), color = "green4") +
  labs(x = "X",
       y = "Y",
       color ="",
       title = paste0("M2 - MSE : ", round(r2b_1, 0))) +
  theme_bw() +
  theme(legend.position = "bottom") -> plotb_1

df %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2, color = echantillon)) + 
  scale_color_manual(values=c("black", "grey85")) +
  geom_line(data=df_echant_pred, aes(x = V1, y = pred_2), color = "red") +
  geom_point(aes(x = V1, y = pred_2), color = "green4") +
  labs(x = "X",
       y = "Y",
       color ="",
       title = paste0("M3 - MSE : ", round(r2b_2, 0))) +
  theme_bw() + 
  guides(color=FALSE) -> plotb_2

df %>% 
  ggplot() + 
  geom_point(aes(x = V1, y = V2, color = echantillon)) + 
  scale_color_manual(values=c("black", "grey85")) +
  geom_point(aes(x = V1, y = pred_3), color = "green4") +
  geom_line(data=df_echant_pred, aes(x = V1, y = pred_3), color = "red") +
  labs(x = "X",
       y = "Y",
       color ="",
       title = paste0("M4 - MSE : ", round(r2b_3, 0))) + 
  guides(color=FALSE) +
  ylim(0, 6000) + 
  theme_bw() -> plotb_3

plotb_0 + plotb_1 + plotb_2
