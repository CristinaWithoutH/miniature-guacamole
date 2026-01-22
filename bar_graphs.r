library(tidyverse)
library(dplyr)

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

# making generation column for relative data
global_relative_data <- read_csv("global_yearly_genres_relative.csv")       
# print(global_relative_data)

generation_data_relative <- global_relative_data |>
  mutate(generation = sapply(year, category))
# print(generation_data, n = 99)

pivoted_relative <- pivot_longer(generation_data_relative, c("fantasy", "science_fiction", "poetry", "childrens_literature", "scary", "non_fiction", "romance", "history", "young_adult"), names_to = "genre")|>
  filter(generation != "no info") |>
  group_by(generation, genre)|>
  summarize(mean_frequency = mean(value))
# print(pivoted_relative, n=35)

# making bar plot for relative data
ggplot(data = pivoted_relative) +
  aes(x = generation, y = mean_frequency, fill = genre)+
  labs(title = "Relative occurrence of genres by generation of the author",
      x = "Generation",
      y = "Average occurrence", 
      fill = "Genre") +
  scale_fill_discrete(labels = c("Fantasy", "Science fiction", "Poetry", "Children's literature", "Scary", "Non-fiction", "Romance", "History", "Young adult")) +
  scale_x_discrete(limits = c("Greatest gen.", "Silent gen.", "Baby boomer", "Gen. X", "Millennial"), labels = c("Greatest gen.\n(1901-1927)", "Silent gen.\n(1928-1945)", "Baby boomer\n(1946-1964)", "Gen. X\n(1965-1980)", "Millennial(1981-1996)"))+                  # changing order of bar groups
  theme_light() +
  geom_col(width = 0.7, position = "dodge")
ggsave("Average relative occurrence per generation.pdf", width = 10, height = 6)

# making generation column for absolute data
# global_absolute_data <- read_csv("global_yearly_genres_absolute.csv")
# # print(relative_data)

# generation_data_absolute <- global_absolute_data |>
#   mutate(generation = sapply(year, category))
# # print(generation_data, n = 99)

# pivoted_absolute <- pivot_longer(generation_data_absolute, c("fantasy", "science_fiction", "poetry", "childrens_literature", "scary", "non_fiction", "romance", "history", "young_adult"), names_to = "genre")|>
#   filter(generation != "no info") |>
#   group_by(generation, genre)|>
#   summarize(mean_frequency = mean(value))
# print(pivoted_absolute, n =35)

# making bar plot for absolute data
# ggplot(data = pivoted_absolute) +
#   aes(x = generation, y = mean_frequency, fill = genre)+
#   labs(title = "Mean absolute occurrence of genres by generation of the author",
#       x = "Generation", 
#       y = "Average absolute occurrence", 
#       fill = "Genre") +
#   scale_fill_discrete(labels = c("Fantasy", "Science fiction", "Poetry", "Children's literature", "Scary", "Non-fiction", "Romance", "History", "Young adult")) +
#   scale_x_discrete(limits = c("Greatest gen.", "Silent gen.", "Baby boomer", "Gen. X", "Millennial"), labels = c("Greatest gen.\n(1901-1927)", "Silent gen.\n(1928-1945)", "Baby boomer\n(1946-1964)", "Gen. X\n(1965-1980)", "Millennial(1981-1996)"))+
#   theme_light() +
#   geom_col(width = 0.7, position = "dodge")
# ggsave("Average absolute occurrence per generation.pdf", width = 10, height = 6)

