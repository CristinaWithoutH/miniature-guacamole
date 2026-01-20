library("tidyverse")
library("rjson")

data <- fromJSON(file = "C_people.json")

glimpse(data)