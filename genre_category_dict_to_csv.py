
# this script makes our dict usable for analysis in R! 

# initialize which genre category we're looking at
genre_category = "fantasy"

# load csv data file
with open(f"subgenre_results_{genre_category}.csv", encoding = "utf-8") as file:
    headers = file.readline()
    yearly_genres = file.readlines()

# want dict with key = year, value = dict (key = genres, value = frequency)
year_dict = {}
# genre_counter = Counter()
for line in yearly_genres:
    line = line.split(",")
    year = line[1].strip(' ')
    genre = line[2].strip("/\n").strip(' ')
    if genre in ("Fantasy", "Fantasy literature", "Dark fantasy", "Urban fantasy", "Historical fantasy", "High fantasy", "Science fantasy", "Comic fantasy"):
        if year not in year_dict:
            year_dict[year] = {
                'Fantasy' : 0,
                'Fantasy literature' : 0,
                'Dark fantasy' : 0,
                'Urban fantasy' : 0,
                'Historical fantasy' : 0,
                'High fantasy' : 0,
                'Science fantasy' : 0,
                'Comic fantasy' : 0,
            }
        year_dict[year][genre] += 1

# Writing to csv file (absolute values)
with open(f'{genre_category}_global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, Fantasy, Fantasy literature, Dark fantasy, Urban fantasy, Historical fantasy, High fantasy, Science fantasy, Comic fantasy \n')
    for year in year_dict:    
        file.write(f'{year}, {year_dict[year]["Fantasy"]}, {year_dict[year]["Fantasy literature"]}, {year_dict[year]["Science fantasy"]}, {year_dict[year]["Comic fantasy"]} \n')

