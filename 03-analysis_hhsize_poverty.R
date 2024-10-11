# for this to work you need to
# 1)  to uncomment line 121 and 122  of the mod_results.R  file
##       res_content, # uncomment this to add the option to save raw result
##       if (golem::app_dev()) {res_content},
##
# 2) run the tool and click "save simulation raw results", to save the data to data-temp
# 3) run this code


# packages
library(readr)
library(tidyr)
# to load the data
sim_res <- read_rds("data-temp/sim_res.rds")


# to have a look at the data
glimpse(sim_res$policy1$policy_sim_raw)

# to compare policy choices between simulations
policy_baseline <- sim_res$policy0$policy_choices %>%
  as.data.frame()

policy_1 <- sim_res$policy1$policy_choices %>%
  as.data.frame()

diffdf::diffdf(policy_baseline,policy_1 )

# to combine the data of different simualations
loaded_results <- sim_res %>%
  purrr::map(~{.x$policy_sim_raw} %>%
               mutate(policy_name = .x$policy_name)) %>%
  bind_rows()

#  this is the number of rows and columns we would expect
13621 *3
163+1



loaded_results %>%
  count(policy_name)

ncol(loaded_results)

# calculate poverty by hhsize
summarized_results <- loaded_results %>%
  mutate(hhsize = ifelse(hhsize <=8,hhsize, 8 )) %>%
  group_by(hhsize, policy_name) %>%
  summarise(poverty_rate = devCEQ::calc_pov_fgt(x = yc_pa,
                                               pl = pline_mod,
                                               w = weight))

# plot the results
summarized_results %>%
  ggplot(aes(x = hhsize,
             y = poverty_rate,
             col = policy_name
             )) +
  geom_line() +
  scale_y_continuous(limits = c(0, NA))

# save the results to excel or CSV
# writexl::write_xlsx(summarized_results, "results_in_table.xlsx" )
#
# summarized_results %>%
#   write.csv("results.csv")
#


# plot the results (a bit prettier), needs  the ggtheme package
summarized_results %>%
  ggplot(aes(x = hhsize,
             y = poverty_rate,
             col = policy_name
             ))  +
  geom_line(linewidth = 2,
                 alpha = .8) +
  geom_point()+
  ggthemes::theme_hc()+
  ggthemes::scale_color_fivethirtyeight() +
  scale_x_continuous(limits = c(0, 8), breaks = 1:8)+
  scale_y_continuous(limits = c(0,  0.5),
                     labels = scales::percent) +
  labs(title ="Poverty rate",
       subtitle = "Population below poverty line by household size",
       x = "household size",
       y = "poverty rate",
       color = NULL)

