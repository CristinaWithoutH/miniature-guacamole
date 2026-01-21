
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
    year = line[1].strip(' ')
    genre = line[2].strip("/\n").strip(' ')
    if year not in year_dict:
        year_dict[year] = {
            'fantasy' : 0,
            'science_fiction' : 0,
            'poetry' : 0,
            'childrens_literature' : 0,
            'scary' : 0,
            'non_fiction' : 0,
            'romance' : 0,
            'history' : 0,
            'young_adult' : 0,
            'other' : 0
        }
    year_dict[year][genre] += 1

# Writing to csv file (absolute values)
with open('global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, fantasy, science_fiction, poetry, childrens_literature, scary, non_fiction, romance, history, young_adult \n')
    for year in year_dict:    
        file.write(f'{year}, {year_dict[year]['fantasy']}, {year_dict[year]['science_fiction']}, {year_dict[year]['poetry']}, {year_dict[year]['childrens_literature']}, {year_dict[year]['scary']}, {year_dict[year]['non_fiction']}, {year_dict[year]['romance']}, {year_dict[year]['history']}, {year_dict[year]['young_adult']} \n')

# relative choice occurence values
yearly_relative_dict = {}
for year in year_dict:
    count_yearly = 0                    # total authors of that year
    current_year_dict = year_dict[year]
    for genre in current_year_dict:
        count_yearly += current_year_dict[genre]
    if year not in yearly_relative_dict:
            yearly_relative_dict[year] = {
                'fantasy' : 0,
                'science_fiction' : 0,
                'poetry' : 0,
                'childrens_literature' : 0,
                'scary' : 0,
                'non_fiction' : 0,
                'romance' : 0,
                'history' : 0,
                'young_adult' : 0
            }
    for genre in current_year_dict:
        relative_genre = current_year_dict[genre] / count_yearly
        yearly_relative_dict[year][genre] = relative_genre
print(yearly_relative_dict)

# Writing to CSV file (relative files)
with open('global_yearly_genres_relative.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, fantasy, science_fiction, poetry, childrens_literature, scary, non_fiction, romance, history, young_adult \n')
    for year in yearly_relative_dict:
        file.write(f'{year}, {yearly_relative_dict[year]['fantasy']}, {yearly_relative_dict[year]['science_fiction']}, {yearly_relative_dict[year]['poetry']}, {yearly_relative_dict[year]['childrens_literature']}, {yearly_relative_dict[year]['scary']}, {yearly_relative_dict[year]['non_fiction']}, {yearly_relative_dict[year]['romance']}, {yearly_relative_dict[year]['history']}, {yearly_relative_dict[year]['young_adult']} \n')