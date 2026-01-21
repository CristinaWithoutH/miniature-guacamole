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
    return("Millenial")
  } else {
    return("no info")
  }
}

# making generation column for relative data
relative_data <- read_csv("yearly_genres_relative.csv")       
# print(relative_data)

generation_data_relative <- relative_data |>
  mutate(generation = sapply(year, category))
# print(generation_data, n = 99)

pivoted_relative <- pivot_longer(generation_data_relative, c("fantasy", "science_fiction", "poetry", "satire", "observational_comedy", "non_fiction", "romance_novel"), names_to = "genre")|>
  filter(generation != "no info") |>
  group_by(generation, genre)|>
  summarize(mean_frequency = mean(value))
# print(pivoted_relative, n=35)

# making bar plot for relative data
ggplot(data = pivoted_relative) +
  aes(x = generation, y = mean_frequency, fill = genre)+
  labs(title = "Average relative occurrence of genres by generation of the author",
      x = "Generation",
      y = "Average relative occurrence", 
      fill = "Genre") +
  scale_fill_discrete(labels = c("Fantasy", "Non-fiction", "Observational comedy", "Poetry", "Romance novel", "Satire", "Science Fiction")) +
  scale_x_discrete(limits = c("Greatest gen.", "Silent gen.", "Baby boomer", "Gen. X", "Millenial"))+                  # changing order of bar groups
  theme_light() +
  geom_col(width = 0.7, position = "dodge")
# ggsave("Average relative occurrence per generation.pdf", width = 10, height = 6)

# making generation column for absolute data
absolute_data <- read_csv("yearly_genres_absolute.csv")
# print(relative_data)

generation_data_absolute <- absolute_data |>
  mutate(generation = sapply(year, category))
# print(generation_data, n = 99)

pivoted_absolute <- pivot_longer(generation_data_absolute, c("fantasy", "science_fiction", "poetry", "satire", "observational_comedy", "non_fiction", "romance_novel"), names_to = "genre")|>
  filter(generation != "no info") |>
  group_by(generation, genre)|>
  summarize(mean_frequency = mean(value))
# print(pivoted_absolute, n =35)

# making bar plot for absolute data
ggplot(data = pivoted_absolute) +
  aes(x = generation, y = mean_frequency, fill = genre)+
  labs(title = "Mean absolute occurrence of genres by generation of the author",
      x = "Generation", 
      y = "Average absolute occurrence", 
      fill = "Genre") +
  scale_fill_discrete(labels = c("Fantasy", "Non-fiction", "Observational comedy", "Poetry", "Romance novel", "Satire", "Science Fiction")) +
  scale_x_discrete(limits = c("Greatest gen.", "Silent gen.", "Baby boomer", "Gen. X", "Millenial"))+
  theme_light() +
  geom_col(width = 0.7, position = "dodge")
# ggsave("Average absolute occurrence per generation.pdf", width = 10, height = 6)

