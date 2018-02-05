
library(data.table)
library(readr)
library(dplyr)
library(tidyr)
library(Lahman)
library(MASS)

library(broom)
library(ggplot2)


f <- file.choose("/Users/shuhe/Dropbox/data_analysis/AVAZU/click1.csv")
df_dataset <- read.csv(f)
#df_dataset <- read.csv(file = "click.csv", header = TRUE, sep = ",")
select (df_dataset,click, banner_pos)
summary = df_dataset %>%
  group_by(banner_pos) %>%
  summarize(click_no = sum(click), count = length(click), click_rate = click_no/count, v = sd(click)*sd(click)) %>%
  filter(banner_pos < 3)


estBetaParams <- function(mu, var) {
  alpha <- ((1 - mu) / var - 1 / mu) * mu ^ 2
  beta <- alpha * (1 / mu - 1)
  return(c(alpha, beta))
}

e1 = estBetaParams(summary[1,]$click_rate,summary[1,]$v)
e2 = estBetaParams(summary[2,]$click_rate,summary[2,]$v)


alpha0 = c(e1[1],e2[1])
beta0 = c(e1[2],e2[2])

summary$alpha0 = alpha0
summary$beta0 = beta0

summary <- summary %>%
  mutate(eb_estimate = (click_no + alpha0) / (count + alpha0 + beta0)) %>%
  mutate(alpha1 = click_no + alpha0,
         beta1 = count - click_no + beta0) %>%
  arrange(desc(eb_estimate))
summary$color = c('1','0')

summary %>%
  inflate(x = seq(.15, .22, .00025)) %>%
  mutate(density = dbeta(x, alpha1, beta1)) %>%
  ggplot(aes(x, density, color = color)) +
  geom_line() +
  labs(x = "click rate average", color = 'banner position')

p0 <- summary %>% filter(banner_pos == 0)
p1<- summary %>% filter(banner_pos == 1)
######################################################
pp0 <- rbeta(1e6, p0$alpha1, p0$beta1)
pp1<- rbeta(1e6, p1$alpha1, p1$beta1)

sim <- mean(pp1 > pp0)
sim
#######################################################
d <- .00002
limits <- seq(.15, .22, d)
sum(outer(limits, limits, function(x, y) {
  (x > y) *
    dbeta(x, p1$alpha1, p1$beta1) *
    dbeta(y, p0$alpha1, p0$beta1) *
    d ^ 2
}))

#######################################################
h <- function(alpha_a, beta_a,
              alpha_b, beta_b) {
  j <- seq.int(0, round(alpha_b) - 1)
  log_vals <- (lbeta(alpha_a + j, beta_a + beta_b) - log(beta_b + j) -
                 lbeta(1 + j, beta_b) - lbeta(alpha_a, beta_a))
  1 - sum(exp(log_vals))
}

h(p1$alpha1, p1$beta1,
  p0$alpha1, p0$beta1)
#########################################################assume two normal distribution
h_approx <- function(alpha_a, beta_a,
                     alpha_b, beta_b) {
  u1 <- alpha_a / (alpha_a + beta_a)
  u2 <- alpha_b / (alpha_b + beta_b)
  var1 <- alpha_a * beta_a / ((alpha_a + beta_a) ^ 2 * (alpha_a + beta_a + 1))
  var2 <- alpha_b * beta_b / ((alpha_b + beta_b) ^ 2 * (alpha_b + beta_b + 1))
  pnorm(0, u2 - u1, sqrt(var1 + var2))
}

h_approx(p1$alpha1, p1$beta1, p0$alpha1, p0$beta1)
###########################################################










