library(tidyverse)
library(gganimate)
library(ggthemes)

beer_states <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_states.csv')

beer_states %>% 
    filter(state == "total") %>% 
    group_by(type) %>%
    mutate(growth = (barrels - lag(barrels)) / lag(barrels)) %>% 
    filter(year > 2008) %>% 
    ggplot(aes(as.integer(year), growth, color = type)) +
    geom_line() +
    geom_point(aes(group = seq_along(year))) +
    geom_text(aes(label = scales::percent(growth, 0.1)),
              size = 3.5, nudge_y = 0.03) +
    scale_x_continuous(limit = c(2008,2020), 
                       expand = c(0,0),
                       breaks = c(2009:2019)) +
    scale_y_continuous(labels = scales::percent, 
                       limit = c(-0.25,0.97), 
                       expand = c(0,0)) +
    scale_color_brewer(palette = "Dark2",
                       breaks = c("On Premises", "Bottles and Cans", "Kegs and Barrels")) +
    labs(title = "Growth of Total Barrels Produced in the USA", x = "Year", y = "Growth", color = "Type") +
    theme_economist() +
    transition_reveal(year)