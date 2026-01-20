
# make table usable for analysis in R!

# import packages
import json
from collections import Counter

# load csv data file
with open("writers_results.csv", encoding = "utf-8") as file:
    headers = file.readline()
    yearly_genres = file.readlines()

# want dict with key = year, value = dict (key = genres, value = frequency)
year_dict = {}
# genre_counter = Counter()
for line in yearly_genres:
    line = line.split(",")
    year = line[1]
    genre = line[2].strip("/\n")
    if year not in year_dict:
        year_dict[year] = {}
    else:
        if genre not in year_dict[year]:
            year_dict[year][genre] = 1 
        else:
            year_dict[year][genre] += 1


print(year_dict)

