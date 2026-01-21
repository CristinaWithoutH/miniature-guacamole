library(tidyverse)

my_data <- read_csv("yearly_genres.csv")
print(my_data)

pivoted <- pivot_longer(my_data, c("fantasy", "science_fiction", "poetry", "satire", "observational_comedy", "non_fiction", "romance_novel"), names_to = "genre")
print(pivoted)

ggplot(data = pivoted) +
  aes(x = year, y = value, color = genre) +
  labs(title = "Relative occurrence of genres by birth year of the author",
      x = "Year of birth", 
      y = "Relative occurrence", 
      color = "Genre") +
  theme_light() +
  scale_colour_discrete(labels = c("Fantasy", "Non fiction", "Observational comedy", "Poetry", "Romance novel", "Satire", "Science fiction")) +
  geom_vline(xintercept = 1927, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1945, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1964, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1980, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1996, linetype = "dashed", color = 'grey50') +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE)
ggsave("Relative occurrence by genre.pdf", width = 10, height = 6)