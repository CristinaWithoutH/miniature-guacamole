# import packages
import json
from collections import Counter

# open data
writers_dict = {}  
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
for letter in letters:
    with open(f'data\{letter}_people.json') as file:
        persons = json.load(file)

# make dictionary with key: Name, value: dict(Year, Genre, Nationality) each row is 1 person  # genre: ontology/genre_label
        for person in persons:      # loop through people who have all the data we need
            if "ontology/genre_label" in person and "ontology/nationality_label" in person and "ontology/birthYear" in person and ("Writer" or "Author" in person.values()):
                name = person["title"]                                # define variables for clarity
                birth_year = person["ontology/birthYear"]
                genre_list = person["ontology/genre_label"]
                nationality = person["ontology/nationality_label"]
                writers_dict[name] = {
                    "birth_year": birth_year,      
                    "genre": genre_list,      # genre
                    "nationality": nationality
                }
    # notes for later: 
    # 1. need to filter more broadly so actually including all writers + authors (eg currently excluding ppl who have "Author" detailed in a list)
    # 2. also include people who don't have a datapoint for nationality
    # print(writers_dict)

    with open("writers_results.json", "w", encoding = "utf-8") as file:
        json.dump(writers_dict, file, indent = 4)

# counting how many instances of each genre we have right now
# genre_count = Counter()
# for writer in writers_dict:
#     writer_info = writers_dict[writer]
#     genre_list = writer_info["genre"]
#     for genre in genre_list:
#         if genre not in genre_count:
#             genre_count[genre] = 1
#         else:
#             genre_count[genre] += 1

# print(genre_count)