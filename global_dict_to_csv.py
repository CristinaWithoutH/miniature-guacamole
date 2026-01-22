
# make table usable for analysis in R!

# import packages
import json
from collections import Counter

# load csv data file
with open("global_writers_results.csv", encoding = "utf-8") as file:
    headers = file.readline()
    yearly_genres = file.readlines()

# want dict with key = year, value = dict (key = genres, value = frequency)
year_dict = {}
# genre_counter = Counter()
for line in yearly_genres:
    line = line.split(",")
    year = line[1].strip(' ')
    genre = line[2].strip("/\n").strip(' ')
    if year not in year_dict:
        year_dict[year] = {
            'childrens_literature' : 0,
            'fantasy' : 0,
            'horror_thriller' : 0,
            'romance' : 0,
            'science_fiction' : 0,
            'young_adult' : 0, 
            'other' : 0
        }
    year_dict[year][genre] += 1

# Writing to csv file (absolute values)
with open('global_yearly_genres.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, childrens_literature, fantasy, horror_thriller, romance, science_fiction, young_adult \n')
    for year in year_dict:    
        file.write(f'{year}, {year_dict[year]["childrens_literature"]}, {year_dict[year]["fantasy"]}, {year_dict[year]["horror_thriller"]}, {year_dict[year]["romance"]}, {year_dict[year]["science_fiction"]}, {year_dict[year]["young_adult"]}\n')


