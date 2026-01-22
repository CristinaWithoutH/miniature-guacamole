library(tidyverse)

fantasy_data <- read_csv("fantasy_global_yearly_genres_absolute.csv")
horror_data <- read_csv("horror_global_yearly_genres_absolute.csv")
sf_data <- read_csv("science fiction_global_yearly_genres_absolute.csv")
ya_data <- read_csv("young-adult_global_yearly_genres_absolute.csv")

#fantasy pivoting + visualising line plot
fantasy_pivot <- pivot_longer(fantasy_data, c("Fantasy", "Fantasy literature", "Dark fantasy", "Urban fantasy", "Historical fantasy", "High fantasy", "Science fantasy", "Comic fantasy"), names_to = "fantasy_genre")

ggplot(data = fantasy_pivot) +
  aes(x = year, y = value, color = fantasy_genre)+
  labs(title = "Breakdown of absolute occurrence of fantasy sub-genres",
      x = "Year",
      y = "Frequency", 
      color = "Fantasy sub-genres") +
  theme_light() +
  geom_smooth(method = "lm", se = FALSE)
# ggsave("Fantasy sub-genre absolute breakdown.pdf", width = 10, height = 6)

#horror pivoting + visualising line plot
horror_pivot <- pivot_longer(horror_data, c("Horror fiction", "Thriller (genre)", "Techno-thriller", "Legal thriller", "Psychological thriller"), names_to = "horror_genre")

ggplot(data = horror_pivot) +
  aes(x = year, y = value, color = horror_genre)+
  labs(title = "Breakdown of absolute occurrence of horror sub-genres",
      x = "Year",
      y = "Frequency", 
      color = "Horror sub-genres") +
  theme_light() +
  geom_smooth(method = "lm", se = FALSE)
# ggsave("Horror sub-genre absolute breakdown.pdf", width = 10, height = 6)

#science fiction pivoting + visualising line plot
sf_pivot <- pivot_longer(sf_data, c("Science fiction", "Hard science fiction", "Social science fiction"), names_to = "sf_genre")

ggplot(data = sf_pivot) +
  aes(x = year, y = value, color = sf_genre)+
  labs(title = "Breakdown of absolute occurrence of science fiction sub-genres",
      x = "Year",
      y = "Frequency", 
      color = "Science fiction sub-genres") +
    theme_light() +
  geom_smooth(method = "lm", se = FALSE)
# ggsave("SF sub-genre absolute breakdown.pdf", width = 10, height = 6)

#young adult pivoting + visualising line plot
ya_pivot <- pivot_longer(ya_data, c("Young-adult fiction", "Adolescence"), names_to = "ya_genre")

ggplot(data = ya_pivot) +
  aes(x = year, y = value, color = ya_genre)+
  labs(title = "Breakdown of absolute occurrence of young adult sub-genres",
      x = "Year",
      y = "Frequency", 
      color = "Young adult sub-genres") +
    theme_light() +
  geom_smooth(method = "lm", se = FALSE)
# ggsave("YA sub-genre absolute breakdown.pdf", width = 10, height = 6)
