library(tidyverse)

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
global_data_absolute_by_gen <- global_data |> 
  mutate(generation = sapply(year, category)) |>
  select(childrens_literature, young_adult, generation, year) |>
  pivot_longer(c(childrens_literature, young_adult), names_to = "genre", values_to = "absolute_occurrence") |>
  filter(generation != "no info") |>
  mutate(
    generation = as.factor(generation),
    genre = as.factor(genre)
  ) |>
  mutate(generation = fct_reorder(generation, year)) |>
  group_by(generation, genre)|>
  mutate(total_observations = sum(absolute_occurrence)) |>
  print()

global_data_relative_by_gen <- global_data |>
  mutate(generation = sapply(year, category)) |>
  select(childrens_literature, young_adult, generation, year) |> 
  pivot_longer(c(childrens_literature, young_adult), names_to = "genre", values_to = 'absolute_frequency') |>
  filter(generation != 'no info') |>
  mutate(
      generation = as.factor(generation),
      genre = as.factor(genre)
  ) |>
  mutate(generation = fct_reorder(generation, year)) |>
  select(-year) |>
  group_by(generation) |>
  mutate(total_observations = sum(absolute_frequency)) |>
  group_by(genre, generation) |>
  mutate(relative_frequency = sum(absolute_frequency)/total_observations) 

# Visualization: bar plot for relative occurrence
ggplot(global_data_relative_by_gen) +
  aes(x = genre, y = relative_frequency, fill = generation)+
  labs(title = "Relative Frequency of Children's Literature and Young Adult",
      subtitle = "by Generation of the Author",
      x = "Genre",
      y = "Relative frequency", 
      fill = "Generation"
    ) +
  theme_light(base_size = 15) +
  geom_col(width = 0.7, position = "dodge", colour = 'black') +
  scale_x_discrete(labels = c("Children's literature", "Young adult")) +    
  scale_fill_discrete(palette = scales::pal_grey())
ggsave("CL YA relative genre occurrence barplot.pdf", width = 10, height = 5)

# Visualization: bar plot for absolute occurrence
ggplot(global_data_absolute_by_gen) +
  aes(x = genre, y = total_observations, fill = generation)+
  labs(title = "Absolute Frequency of Children's Literature and Young Adult",
      subtitle = "by Generation of the Author",
      x = "Genre", 
      y = "Absolute frequency", 
      fill = "Generation") +
  theme_light(base_size = 15) +
  geom_col(width = 0.7, position = "dodge", colour = "black") +
  scale_x_discrete(labels = c("Children's literature", "Young adult")) +           
  scale_fill_discrete(palette = scales::pal_grey())
ggsave("CL YA absolute genre occurrence barplot.pdf", width = 9, height = 5)

# Visualization: line plot for absolute occurrence 
ggplot(data = global_data_absolute_by_gen) +
  aes(x = year, y = absolute_occurrence, color = genre) +
  labs(title = "Absolute Frequency of Children's Literature and Young Adult",
      subtitle = "by Generation of the Author",
      x = "Year of birth", 
      y = "Absolute frequency", 
      color = "Genre",) +
  theme_light(base_size = 15) +
  scale_colour_discrete(labels = c("Children's literature", "Young adult")) +
  geom_vline(xintercept = 1927, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1945, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1964, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1980, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1996, linetype = "dashed", color = 'grey50') +
  annotate("text", x = 1912, y = 10, label = "Greatest Gen.\n ('01-'27)") +
  annotate("text", x = 1936, y = 10, label = "Silent Gen.\n ('28-'45)") +
  annotate("text", x = 1954, y = 10, label = "Baby \n Boomers\n ('46-'64)") +
  annotate("text", x = 1972, y = 10, label = "Gen. X\n ('65-'80)") +
  annotate("text", x = 1988, y = 10, label = "Millenials\n ('81-'96)") +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE)
ggsave("CL YA absolute genre occurrence lineplot.pdf", width = 12, height = 7)