# Run simulation in R console

library(dplyr)
library(readr)
library(scales)

# R-package with simulation code (and the app)
library("GeoappPackage")

# Data load -----------------------------------------
dta_presim <- read_rds("data/presim.rds")
dta_baseline <- read_rds("data/baseline.rds")

# Simulation inputs ---------------------------------
inp_bl <- baseline_inputs()

## Exploring individual inputs
names(inp_bl)

inp_bl$simu_tsa_value
inp_bl$tsa_under_16
inp_bl$tsa_over_16

# Run baseline simulation -----------------------------

bl_result <- full_ceq(inps = inp_bl, presim = dta_presim)

## Explore the data
bl_result |> View()
bl_result |> names()
bl_result |> glimpse()

## Selecting variables for analysis
bl_1 <- bl_result |> select(familysize, weight, gender, yd_pc, yc_pc)
bl_1 |> glimpse()

# Calculate the poverty rate
bl_1 |> 
  mutate(poor = yd_pc < 2500) |> 
  group_by(poor) |> 
  summarise(
    headcount_1 = n(),
    headcount = sum(weight)) |> 
  ungroup() |> 
  mutate(poverty_rate = headcount / sum(headcount))

# Income distribution

bl_1 |> 
  ggplot() + 
  aes(x = yc_pc, weight = weight, fill = "Consumable") + 
  geom_density(alpha = 0.1 )+ 
  scale_x_continuous(limits = c(0, 15000), n.breaks = 10)

# Income by gender

bl_1 |> 
  mutate(sex = ifelse(gender == 1, "Male", "Female")) |> 
  ggplot() + 
  aes(x = yc_pc, weight = weight, fill = sex) + 
  geom_density(alpha = 0.1) + 
  scale_x_continuous(limits = c(0, 15000), n.breaks = 10)

# Changing individual inputs -----------------------------------------

ins_notsa <- inp_bl
ins_notsa$simu_tsa_value <- 1
ins_notsa$tsa_under_16 <- 0
ins_notsa$tsa_over_16 <- 0

no_tsa_result <- GeoappPackage::full_ceq(ins_notsa, dta_presim)

## Calculating poverty 

no_tsa_result |> 
  mutate(poor = yd_pc < 2500) |> 
  group_by(poor) |> 
  summarise(
    headcount_1 = n(),
    headcount = sum(weight)) |> 
  ungroup() |> 
  mutate(poverty_rate = headcount / sum(headcount))

# Building a Lorenz curve

bl_result |> select(weight, yc_pc) |> mutate(Simulation = "Baseline") |>
  bind_rows(no_tsa_result |> select(weight, yc_pc) |> mutate(Simulation = "No TSA")) |>
  group_by(Simulation) |> 
  arrange(yc_pc) |> 
  mutate(
    yc_cum = cumsum(yc_pc) / max(cumsum(yc_pc)),
    wt_cum = cumsum(weight) / max(cumsum(weight))
  ) |> 
  ungroup() |> 
  ggplot() + 
  aes(x = wt_cum, y = yc_cum, colour = Simulation) + 
  geom_line() + 
  geom_abline(slope = 1, intercept = 0, colour = "black") + 
  scale_x_continuous("% of population", labels = scales::percent) + 
  scale_y_continuous("% total income", labels = scales::percent) +
  theme_bw() 
