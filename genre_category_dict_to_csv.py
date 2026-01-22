
# this script makes our dict usable for analysis in R! 

# initialize which genre category we're looking at
genre_category = "horror"

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
    if genre in ("Horror fiction", "Thriller (genre)", "Techno-thriller", "Legal thriller", "Psychological thriller"):
        if year not in year_dict:
            year_dict[year] = {
                'Horror fiction' : 0,
                'Thriller (genre)' : 0,
                'Techno-thriller' : 0,
                'Legal thriller' : 0,
                'Psychological thriller' : 0

            }
        year_dict[year][genre] += 1

# Writing to csv file (absolute values)
with open(f'{genre_category}_global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
    file.write('year, Horror fiction, Thriller (genre), Techno-thriller, Legal thriller, Psychological thriller \n')
    for year in year_dict:    
        file.write(f'{year}, {year_dict[year]["Horror fiction"]}, {year_dict[year]["Thriller (genre)"]}, {year_dict[year]["Techno-thriller"]},{year_dict[year]["Legal thriller"]}, {year_dict[year]["Psychological thriller"]}  \n')

# subcategories here:

# fantasy:
# genre_counter = Counter()
# if year not in year_dict:
        # if genre in ("Fantasy", "Fantasy literature", "Dark fantasy", "Urban fantasy", "Historical fantasy", "High fantasy", "Science fantasy", "Comic fantasy"):
        #     year_dict[year] = {
        #         'Fantasy' : 0,
        #         'Fantasy literature' : 0,
        #         'Dark fantasy' : 0,
        #         'Urban fantasy' : 0,
        #         'Historical fantasy' : 0,
        #         'High fantasy' : 0,
        #         'Science fantasy' : 0,
        #         'Comic fantasy' : 0,
        #     }
# Writing to csv file (absolute values)
# with open(f'{genre_category}_global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
#     file.write('year, Fantasy, Fantasy literature, Dark fantasy, Urban fantasy, Historical fantasy, High fantasy, Science fantasy, Comic fantasy \n')
#     for year in year_dict:    
#         file.write(f'{year}, {year_dict[year]["Fantasy"]}, {year_dict[year]["Fantasy literature"]}, {year_dict[year]["Science fantasy"]}, {year_dict[year]["Comic fantasy"]} \n')

# science fiction:
# if genre in ("Science fiction", "Hard science fiction", "Social science fiction"):
#         if year not in year_dict:
#             year_dict[year] = {
#                 'Science fiction' : 0,
#                 'Hard science fiction' : 0,
#                 'Social science fiction' : 0
#             }
#         year_dict[year][genre] += 1

# # Writing to csv file (absolute values)
# with open(f'{genre_category}_global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
#     file.write('year, Science fiction, Hard science fiction, Social science fiction \n')
#     for year in year_dict:    
#         file.write(f'{year}, {year_dict[year]["Science fiction"]}, {year_dict[year]["Hard science fiction"]}, {year_dict[year]["Social science fiction"]}\n')
# 
# children: excluded all but children's literature because they were on music 

# young adult:
# if genre in ("Young-adult fiction", "Adolescence"):
#         if year not in year_dict:
#             year_dict[year] = {
#                 'Young-adult fiction' : 0,
#                 'Adolescence' : 0,
#             }
#         year_dict[year][genre] += 1

# # Writing to csv file (absolute values)
# with open(f'{genre_category}_global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
#     file.write('year, Young-adult fiction, Adolescence \n')
#     for year in year_dict:    
#         file.write(f'{year}, {year_dict[year]["Young-adult fiction"]}, {year_dict[year]["Adolescence"]}\n')

# thriller/horror: (called horror)
#  if genre in ("Horror fiction", "Thriller (genre)", "Techno-thriller", "Legal thriller", "Psychological thriller"):
#         if year not in year_dict:
#             year_dict[year] = {
#                 'Horror fiction' : 0,
#                 'Thriller (genre)' : 0,
#                 'Techno-thriller' : 0,
#                 'Legal thriller' : 0,
#                 'Psychological thriller' : 0

#             }
#         year_dict[year][genre] += 1

# # Writing to csv file (absolute values)
# with open(f'{genre_category}_global_yearly_genres_absolute.csv', 'w', encoding = 'utf-8') as file:
#     file.write('year, Horror fiction, Thriller (genre), Techno-thriller, Legal thriller, Psychological thriller \n')
#     for year in year_dict:    
#         file.write(f'{year}, {year_dict[year]["Horror fiction"]}, {year_dict[year]["Thriller (genre)"]}, {year_dict[year]["Techno-thriller"]},{year_dict[year]["Legal thriller"]}, {year_dict[year]["Psychological thriller"]}  \n')
