# import packages
import json
from collections import Counter

# make dictionary with key: Name, value: dict(Year, Genre)   
writers_dict = {}           # initialize
observations_count = 0
duplicates = 0
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
for letter in letters:
    with open(f'data\{letter}_people.json') as file:
        persons = json.load(file)
        for person in persons:     

            # check if person has genre, birthyear, is writer step by step
            has_genre = False
            if "ontology/genre_label" in person:
                has_genre = True
            
            has_birthyear = False
            if "ontology/birthYear" in person:
                has_birthyear = True
                birth_year = person["ontology/birthYear"]                  # already define year here
            elif "ontology/birthDate" in person:
                has_birthyear = True
                if type(person["ontology/birthDate"]) is string:   # date is in format 1990-11-14 (only if it's a string)
                    date = person["ontology/birthDate"].split("-")
                    birth_year = date[0]                                      # or here (i think this doesn't work yet)

            is_writer = False      
            if "http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label" in person:
                for string in person["http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label"]:
                    if "author" in string.lower() or "writer" in string.lower():
                        is_writer = True
            if "http://purl.org/dc/elements/1.1/description" in person:
                if type(person["http://purl.org/dc/elements/1.1/description"]) is string:     # only if it's a string because it's a list for like 1 person
                    if "author" in ["http://purl.org/dc/elements/1.1/description"].lower() or "writer" in person["http://purl.org/dc/elements/1.1/description"].lower():
                            is_writer = True

            # start actual loop if all conditions met
            if has_genre == True and has_birthyear == True and is_writer == True and type(birth_year) is str:    # check type of birthyear bc there's one item with a list
                name = person["title"].replace(",", " ")                 # define variables for clarity, remove comma bc some people have a comma in name
                genre = person["ontology/genre_label"]                 # this is a list for some people, and a string for others
                birth_year = int(birth_year)
                if 1900 <= birth_year <= 2000:                         # filter for 20th century authors
                    if type(genre) is list:                              # if it's a string, add the writer separately for each genre
                        for one_genre in genre:
                            if one_genre == "Fantasy"  or one_genre == "Poetry" or one_genre == "Satire" or one_genre == "Science fiction" or one_genre == "Observational comedy" or one_genre == "Non-fiction" or one_genre == "Romance novel":
                                writers_dict[f"{name} {one_genre}"] = {
                                    "birth_year": birth_year,      
                                    "genre": one_genre 
                                }
                                observations_count += 1
                                duplicates += 1
                    else:                                                # if it's a string, just add the writer once
                        if genre == "Fantasy"  or genre == "Poetry" or genre == "Satire" or genre == "Science fiction" or genre == "Observational comedy" or genre == "Non-fiction" or genre == "Romance novel":
                            writers_dict[name] = {
                                "birth_year": birth_year,      
                                "genre": genre  
                            }
                            observations_count += 1

print(observations_count)
print(duplicates)

# Writing to CSV file
with open('writers_results.csv', 'w', encoding = 'utf-8') as file:
    file.write('name, birth_year, genre\n')
    for name in writers_dict:
        file.write(f'{name}, {writers_dict[name]["birth_year"]}, {writers_dict[name]["genre"]}\n')

# counting how many instances of each genre we have right now
genre_count = Counter()
for writer in writers_dict:
    writer_info = writers_dict[writer]
    genre = writer_info["genre"]
    if genre not in genre_count:
        genre_count[genre] = 1
    else:
        genre_count[genre] += 1

# print(genre_count)

# for Germany analysis: this is the key for nationality: "ontology/nationality_label"

# Calculate the relative choice popularity
# total_genre_occurence = 0
