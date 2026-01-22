library(tidyverse)
library(dplyr)

american_relative_data <- read_csv("american_yearly_genres_relative.csv")
american_absolute_data <- read_csv("american_yearly_genres_absolute.csv")


#creating filtering for new column
category <- function(year) {
  if (year <= 1914){
    return("Political reform")
  } else if (year <= 1933) {
    return("War, prosperity and the Great Depression") 
  } else if(year <=1945) {
    return("New Deal and World War II")
  } else if(year <=1960){
    return("Postwar America")
  } else if(year <=1980){
    return("Civil unrest and social reforms")
  } else if(year<=2000){
    return("End of the century")
  } else {
    return("no info")
  }
}

# Generation grouping + Pivot longer for relative and absolute
US_period_relative <- american_relative_data |>
  mutate(period = sapply(year, category))
relative_pivoted <- pivot_longer(US_period_relative, c("fantasy", "poetry", "science_fiction", "romance"), names_to = "genre")|>
  filter(period != "no info") |>
  group_by(period, genre)|>
  summarize(mean_frequency = mean(value))
absolute_pivoted <- pivot_longer(american_absolute_data, c("fantasy", "poetry", "science_fiction", "romance"), names_to = "genre")


# # Visualization: bar plot for relative occurrence
ggplot(data = relative_pivoted) +
  aes(x = period, y = mean_frequency, fill = genre)+
  labs(title = "Relative genre occurrence by period in US history the author was born in",
      x = "Period in US history",
      y = "Average occurrence", 
      fill = "Genre") +
  scale_fill_discrete(labels = c("Fantasy", "Poetry", "Science fiction", "Romance")) +
  scale_x_discrete(limits = c("Political reform", "War, prosperity and the Great Depression", "New Deal and World War II", "Postwar America", "Civil unrest and social reforms", "End of the century"), 
    labels = c("Political reform\n(1900-1914)", "War, prosperity and\n the Great Depression\n(1914-1933)", "New Deal and\n World War II\n(1933-1945)", "Postwar America\n(1945-1960)", "Civil unrest and\n social reform\n(1960-1980)", "End of the century\n(1980-2000)")) +          
  theme_light() +
  geom_col(width = 0.6, position = "dodge")
ggsave("Relative US occurrence of genre per generation.pdf", width = 10, height = 6)

# Visualization: line plot for absolute occurrence 
ggplot(data = absolute_pivoted) +
  aes(x = year, y = value, color = genre) +
  labs(title = "Absolute genre occurrence by period in US history the author was born in",
      x = "Author year of birth", 
      y = "Absolute occurrence", 
      color = "Genre") +
  theme_light() +
  scale_colour_discrete(labels = c("Fantasy", "Poetry", "Science fiction", "Romance")) +
  geom_vline(xintercept = 1914, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1933, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1945, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1960, linetype = "dashed", color = 'grey50') +
  geom_vline(xintercept = 1980, linetype = "dashed", color = 'grey50') +
  annotate("text", size = 3, x = 1907, y = 7, label = "Political reform\n(1900-1914)") +
  annotate("text", size = 3, x = 1923.5, y = 7, label = "War, prosperity\n and the Great\n Depression (1914-1933)") +
  annotate("text", size = 3, x = 1939, y = 7, label = "New Deal and\n World War II\n(1933-1945)") +
  annotate("text", size = 3, x = 1952, y = 7, label = "Postwar America\n(1945-1960)") +
  annotate("text", size = 3, x = 1970, y = 7, label = "Civil unrest\n and social reform\n(1960-1980)") +
  annotate("text", size = 3, x = 1989, y = 7, label = "End of\n the century\n(1980-2000)") +
  geom_point(alpha = 0.3) +
  geom_smooth(method='lm', se = FALSE)
ggsave("Absolute occurrence by genre by gen.pdf", width = 12, height = 6)