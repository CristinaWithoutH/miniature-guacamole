
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
            'Fantasy' : 0,
            'Science fiction' : 0,
            'Observational comedy' : 0,
            'Satire' : 0,
            'Poetry' : 0,
            'Non-fiction' : 0,
            'Romance novel' : 0
        }
    year_dict[year][genre] += 1

# Writing to csv file (absolute values)
with open('yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, fantasy, science_fiction, poetry, satire, observational_comedy, non_fiction, romance_novel \n')
    for year in year_dict:
        file.write(f'{year}, {year_dict[year]['Fantasy']}, {year_dict[year]['Science fiction']}, {year_dict[year]['Poetry']}, {year_dict[year]['Satire']}, {year_dict[year]['Observational comedy']}, {year_dict[year]['Non-fiction']}, {year_dict[year]['Romance novel']}\n')

# relative choice occurence values
yearly_relative_dict = {}
for year in year_dict:
    count_yearly = 0                    # total authors of that year
    current_year_dict = year_dict[year]
    for genre in current_year_dict:
        count_yearly += current_year_dict[genre]
    if year not in yearly_relative_dict:
            yearly_relative_dict[year] = {
                'Fantasy' : 0,
                'Science fiction' : 0,
                'Observational comedy' : 0,
                'Satire' : 0,
                'Poetry' : 0,
                'Non-fiction' : 0,
                'Romance novel' : 0
            }
    for genre in current_year_dict:
        relative_genre = current_year_dict[genre] / count_yearly
        yearly_relative_dict[year][genre] = relative_genre
print(yearly_relative_dict)

# Writing to CSV file (relative files)
with open('yearly_genres_relative.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, fantasy, science_fiction, poetry, satire, observational_comedy, non_fiction, romance_novel \n')
    for year in yearly_relative_dict:
        file.write(f'{year}, {yearly_relative_dict[year]['Fantasy']}, {yearly_relative_dict[year]['Science fiction']}, {yearly_relative_dict[year]['Poetry']}, {yearly_relative_dict[year]['Satire']}, {yearly_relative_dict[year]['Observational comedy']}, {yearly_relative_dict[year]['Non-fiction']}, {yearly_relative_dict[year]['Romance novel']}\n')