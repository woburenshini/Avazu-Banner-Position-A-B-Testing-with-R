# Avazu-Banner-Position-A-B-Testing-with-R

The goal of this A/B test is evaluate the click-through rate (CTR) as an important metric of online advertising. 
Online advertising CTR is define as 

Fist step data preparing

The first step of our Avazu A/B test is load raw dataset and summarize feature of interest.We use dplyr for table manipulation.

library(readr)
library(dplyr)
library(tidyr)
library(Lahman)
library(MASS)
library(broom)
library(ggplot2)
f <- file.choose("./AVAZU/click1.csv")
df_dataset <- read.csv(f)
select (df_dataset,click, banner_pos)
summary = df_dataset %>%
  group_by(banner_pos) %>%
  summarize(click_no = sum(click), count = length(click), click_rate = click_no/count, v = sd(click)*sd(click)) %>%
  filter(banner_pos < 3)
