# Run a list of simulations in R console

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

# Income distribution

bl_result |> 
  ggplot() + 
  aes(x = yc_pc, weight = weight, fill = "Consumable") + 
  geom_density(alpha = 0.1 )+ 
  scale_x_continuous(limits = c(0, 15000), n.breaks = 10)

# Income by gender

bl_result |> 
  mutate(sex = ifelse(gender == 1, "Male", "Female")) |> 
  ggplot() + 
  aes(x = yc_pc, weight = weight, fill = sex) + 
  geom_density(alpha = 0.1) + 
  scale_x_continuous(limits = c(0, 15000), n.breaks = 10)