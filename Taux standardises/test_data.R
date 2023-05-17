titanic_data <- read.csv("Data/titanic-survival.csv")


library(dplyr)

titanic_data %>% group_by(pclass) %>% 
  summarise(tx_survie = sum(survived) / n())


titanic_data %>% group_by(sex) %>% 
  summarise(tx_survie = sum(survived) / n())


titanic_data %>% group_by(pclass) %>% 
  summarise(tx_survie = sum(survived) / n(),
            part_femmes = sum(sex == "female") / n(),
            moy_age = mean(age, na.rm = TRUE))


titanic_data %>% group_by(survived) %>% 
  summarise(tx_survie = sum(survived) / n())


titanic_data %>% mutate(tr_age = case_when(age < 18 ~ 1,
                                           age < 35 ~ 2,
                                           age < 50 ~ 3,
                                           age >= 50 ~ 4)) %>% 
  group_by(pclass, tr_age) %>% 
  summarise(
    eff = n(),
    tx_survie = sum(survived) / n()
  ) %>% View()
