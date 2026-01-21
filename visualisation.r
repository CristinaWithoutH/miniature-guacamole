library(tidyverse)

my_data <- read_csv("yearly_genres.csv")
# print(my_data)

pivoted <- pivot_longer(my_data, c("fantasy", "science_fiction", "poetry", "satire", "observational_comedy", "non_fiction", "romance_novel"), names_to = "genre")
# print(pivoted)

# visualisation of relative occurrence - smooth lines per gen.
ggplot(data = pivoted) +
  aes(x = year, y = value, color = genre) +
  labs(title = "Relative occurrence of genres by generation of the author",
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
  annotate("text", x = 1912, y = 0.75, label = "Greatest Gen.\n ('01-'27)") +
  annotate("text", x = 1936, y = 0.75, label = "Silent Gen.\n ('28-'45)") +
  annotate("text", x = 1954, y = 0.75, label = "Baby \n Boomers\n ('46-'64)") +
  annotate("text", x = 1972, y = 0.75, label = "Gen. X\n ('65-'80)") +
  annotate("text", x = 1988, y = 0.75, label = "Millenials\n ('81-'96)") +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE)
  # geom_smooth(method = "lm", se = FALSE)
ggsave("Relative occurrence by genre by gen.pdf", width = 10, height = 6)