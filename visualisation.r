library(tidyverse)

my_data <- read_csv("writers_results.csv")
# print(my_data)


fantasy = filter(my_data, genre == "Fantasy")
print(fantasy)

comedy = filter(my_data, genre == "Comedy")
print(comedy)

romance = filter(my_data, genre == "Romance novel")

ggplot(data = fantasy) +
  aes (x = birth_year, fill = genre) +
  geom_bar(fill = "magenta")

# ggplot(data = romance) +
#   aes (x = birth_year, fill = genre) +
#   geom_bar()


# ggplot(data = ...) +
#   aes(x = birth_year, y = ..., color = genre) +
#   labs(title = "Relative popularity of genres by birth year of the author",
#       x = "Year of birth", 
#       y = "Relative popularity", 
#       color = "Genre") +
#   theme_light() +
#   scale_colour_discrete(labels = c("",)) +
#   geom_point()
#   geom_line()