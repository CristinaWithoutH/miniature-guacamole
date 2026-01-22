
# this script makes our dict usable for analysis in R!

# load csv data file
with open("american_writers_results.csv", encoding = "utf-8") as file:
    headers = file.readline()
    yearly_genres = file.readlines()

# want dict with key = year, value = dict (key = genres, value = frequency)
year_dict = {}
for line in yearly_genres:
    line = line.split(",")
    year = line[1].strip(' ')
    genre = line[2].strip("/\n").strip(' ')
    if year not in year_dict:
        year_dict[year] = {
            'fantasy' : 0,
            'poetry' : 0,
            'science_fiction' : 0,
            'romance' : 0,
            'other' : 0
        }
    year_dict[year][genre] += 1

# Writing to csv file (absolute values)
with open('american_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, fantasy, poetry, science_fiction, romance \n')
    for year in year_dict:    
        file.write(f'{year}, {year_dict[year]["fantasy"]}, {year_dict[year]["poetry"]}, {year_dict[year]["science_fiction"]}, {year_dict[year]["romance"]} \n')

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
                'poetry' : 0,
                'science_fiction' : 0,
                'romance' : 0,
                'other' : 0
            }
    for genre in current_year_dict:
        relative_genre = current_year_dict[genre] / count_yearly
        yearly_relative_dict[year][genre] = relative_genre
print(yearly_relative_dict)

# Writing to CSV file (relative files)
with open('american_yearly_genres_relative.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, fantasy, poetry, science_fiction, romance \n')
    for year in yearly_relative_dict:
        file.write(f"{year}, {yearly_relative_dict[year]['fantasy']}, {yearly_relative_dict[year]['poetry']}, {yearly_relative_dict[year]['science_fiction']}, {yearly_relative_dict[year]['romance']} \n")
        