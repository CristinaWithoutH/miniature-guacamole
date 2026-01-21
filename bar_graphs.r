library(tidyverse)
library(dplyr)

#creating filtering for new column
category <- function(year) {
  if (year <= 1927){
    return("Greatest gen")
  } else if (year <= 1945) {
    return("Silent gen") 
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
  group_by(generation)
# print(pivoted_relative)

# making bar plot for relative data
ggplot(data = pivoted_relative) +
  aes(x = generation, y = value, fill = genre)+
  geom_col(position = "dodge")
  # geom_col(position = "stack")


# making generation column for absolute data
absolute_data <- read_csv("yearly_genres_absolute.csv")
# print(relative_data)

generation_data_absolute <- absolute_data |>
  mutate(generation = sapply(year, category))
# print(generation_data, n = 99)

pivoted_absolute <- pivot_longer(generation_data_absolute, c("fantasy", "science_fiction", "poetry", "satire", "observational_comedy", "non_fiction", "romance_novel"), names_to = "genre")|>
  filter(generation != "no info") |>
  group_by(generation)
# print(pivoted_absolute)

# making bar plot for absolute data
ggplot(data = pivoted_absolute) +
  aes(x = generation, y = value, fill = genre)+
  geom_col(position = "dodge")
  # geom_col(position = "stack")
