library(tidyverse)
library(dplyr)

global_data <- read_csv("global_yearly_genres.csv")

#creating filtering for new column
category <- function(year) {
  if (year <= 1927){
    return("Greatest gen.")
  } else if (year <= 1945) {
    return("Silent gen.") 
  } else if(year <=1964) {
    return("Baby boomer")
  } else if(year <=1980){
    return("Gen. X")
  } else if(year <=1996){
    return("Millennial")
  } else {
    return("no info")
  }
}

# Pivoting longer and optionally grouping by generation
global_data_absolute <- pivot_longer(global_data, c("childrens_literature", "fantasy", "horror_thriller", "science_fiction", "young_adult"), names_to = "genre", values_to = "absolute_occurrence")
global_data_absolute_no_millenials = filter(global_data_absolute, (year < 1981))            # filtering out millennials as they significantly influence linear regression.

global_data_absolute_by_gen <-global_data_absolute_no_millenials |> 
  mutate(generation = sapply(year, category)) |>
  filter(generation != "no info") |>
  group_by(generation, genre)|>
  mutate(total_observations = sum(absolute_occurrence)) 

global_data_relative_by_gen <- global_data |>
  mutate(generation = sapply(year, category)) |>
  pivot_longer(c("childrens_literature", "fantasy", "horror_thriller", "science_fiction", "young_adult"), names_to = "genre", values_to = 'absolute_frequency') |>
  filter(generation != 'no info') |>
  group_by(generation) |>
  mutate(total_observations = sum(absolute_frequency)) |>
  group_by(generation, genre) |>
  mutate(relative_frequency = sum(absolute_frequency)/total_observations)

# Visualization: bar plot for relative occurrence
ggplot(data = global_data_relative_by_gen) +
  aes(x = generation, y = relative_frequency, fill = genre)+
  labs(title = "Relative genre occurrence by generation of the author",
      x = "Generation",
      y = "Average occurrence", 
      fill = "Genre"
    ) +
  scale_fill_discrete(labels = c("Children's literature", "Fantasy", "Horror / Thriller", "Science fiction", "Young adult")) +
  scale_x_discrete(limits = c("Greatest gen.", "Silent gen.", "Baby boomer", "Gen. X", "Millennial"), labels = c("Greatest gen.\n(1901-1927)", "Silent gen.\n(1928-1945)", "Baby boomer\n(1946-1964)", "Gen. X\n(1965-1980)", "Millennial(1981-1996)"))+                  # changing order of bar groups
  theme_light() +
  geom_col(width = 0.7, position = "dodge", colour = 'black')
ggsave("Relative occurrence of genre per generation barplot.pdf", width = 10, height = 6)

# Supplementary Visualization: bar plot for absolute occurrence (to test reliablility of the relative barplot)
ggplot(global_data_absolute_by_gen) +
  aes(x = generation, y = total_observations, fill = genre)+
  labs(title = "Absolute occurrence of genres by generation of the author",
      x = "Generation", 
      y = "Absolute occurrence", 
      fill = "Genre") +
  scale_fill_discrete(labels = c("Children's literature", "Fantasy", "Horror / Thriller", "Science fiction", "Young adult")) +
  scale_x_discrete(limits = c("Greatest gen.", "Silent gen.", "Baby boomer", "Gen. X"))+
  theme_light() +
  geom_col(width = 0.7, position = "dodge", colour = "black")
ggsave("Absolute occurrence by genre by gen barplot.pdf", width = 10, height = 6)

# Visualization: line plot for absolute occurrence 
ggplot(data = global_data_absolute_no_millenials) +
  aes(x = year, y = absolute_occurrence, color = genre) +
  labs(title = "Absolute genre occurrence by generation of the author",
      x = "Year of birth", 
      y = "Absolute occurrence", 
      color = "Genre",) +
  theme_light() +
  scale_colour_discrete(labels = c("Children's literature", "Fantasy", "Horror / Thriller", "Science fiction", "Young adult")) +
  geom_vline(xintercept = 1927, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1945, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1964, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1980, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1996, linetype = "dashed", color = 'grey50') +
  annotate("text", x = 1912, y = 27, label = "Greatest Gen.\n ('01-'27)") +
  annotate("text", x = 1936, y = 27, label = "Silent Gen.\n ('28-'45)") +
  annotate("text", x = 1954, y = 27, label = "Baby \n Boomers\n ('46-'64)") +
  annotate("text", x = 1972, y = 27, label = "Gen. X\n ('65-'80)") +
  annotate("text", x = 1990, y = 27, label = "Millenials\n ('81-'96)") +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE)
ggsave("Absolute occurrence by genre by gen lineplot (no millenials, linear regression).pdf", width = 10, height = 6)