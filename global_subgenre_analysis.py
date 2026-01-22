
# This script analyzes subgenres of a specified genre category. The results will be used to check if genre groups are 
# sensible or if trends within a group cancel out.

# import packages
import json
from collections import Counter

# 1. initialize variables (update genre category here!)
writers_dict = {}           # writersdict will be a dictionary with key: Name, value: dict(Year, Genre)   
observations_count = 0      # count how many observations including
duplicates = 0              # duplicate people because each person is counted for each of their genres
genre_category = "horror"  # define category one at a time here (rather than looping through all to save loading time)
# categories: science fiction, fantasy, childrens, ya, horror/thriller

# 2. letter loop to go through all files
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
for letter in letters:

    # open data
    with open(f'data\{letter}_people.json') as file:
        persons = json.load(file)

        # 3. loop through each person
        for person in persons:     

            # 3.1 check if person has genre, birthyear, is writer

            # 3.11 check if we have information on their genre(s). poetry is a special case bc often in job description, not genre
            has_genre = False
            append_poetry = False   # extra check for poets!
            if "ontology/genre_label" in person:
                has_genre = True
            elif "http://purl.org/dc/elements/1.1/description" in person:
                if "Poet" in person["http://purl.org/dc/elements/1.1/description"]:       # if poetry listed in description
                    has_genre = True
                    append_poetry = True
                elif "ontology/occupation_label" in person:                               # if poetry listed in occupation
                    if "Poet" in person["ontology/occupation_label"]:
                        has_genre = True
                        append_poetry = True
            
            
            # 3.12 check birthyear. may be in birthyear or in birthdate key.
            has_birthyear = False
            if "ontology/birthYear" in person:                            # if in birthYear key
                birth_year = person["ontology/birthYear"]  
                if type(birth_year) is str and birth_year != '':          # almost always a string, exclude if empty
                    has_birthyear = True
            elif "ontology/birthDate" in person:                          # if no birthYear, check birthDate key
                if type(person["ontology/birthDate"]) is str:         # date is in format 1990-11-14 (almost always a string)
                    date = person["ontology/birthDate"].split("-")
                    birth_year = date[0]
                    if type(date[0]) is str and birth_year != '':          # exclude if empty   
                        has_birthyear = True                                 

            # 3.13 check if person is writer. could be saved in different names or keys
            is_writer = False      
            if "http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label" in person:
                for item in person["http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label"]:
                    if "author" in item.lower() or "writer" in item.lower() or "novelist" in item.lower() or "poet" in item.lower():
                        is_writer = True
            if "http://purl.org/dc/elements/1.1/description" in person:
                if type(person["http://purl.org/dc/elements/1.1/description"]) is str:     # almost always a string
                    if "author" in person["http://purl.org/dc/elements/1.1/description"].lower() or "writer" in person["http://purl.org/dc/elements/1.1/description"].lower() or "novelist" in person["http://purl.org/dc/elements/1.1/description"].lower() or "poet" in person["http://purl.org/dc/elements/1.1/description"].lower():
                        is_writer = True
            if "ontology/occupation_label" in person:                                     # may be a string or list
                if type(person["ontology/occupation_label"]) is list:
                    for item in person["ontology/occupation_label"]:
                        if "author" in item.lower() or "writer" in item.lower() or "novelist" in item.lower() or "poet" in item.lower():
                            is_writer = True
                elif type(person["ontology/occupation_label"]) is str:
                    if "author" in person["ontology/occupation_label"].lower() or "writer" in person["ontology/occupation_label"].lower() or "novelist" in person["ontology/occupation_label"].lower() or "poet" in person["ontology/occupation_label"].lower():
                        is_writer = True

            # 3.2 loop through genres if all conditions met
            if has_genre == True and has_birthyear == True and is_writer == True:    # check type of birthyear bc there's one item with a list 

                # 3.21 define variables
                name = person["title"].replace(",", " ")          # remove comma bc some people have a comma in name
                if "ontology/genre_label" in person:              # genre depends on poetry or not
                    genre = person["ontology/genre_label"]        # this is a list for some people, and a string for others
                    if append_poetry == True:                     # append poetry if it's a poet!
                        genre.append("Poetry")
                else:
                    genre = "Poetry"
                birth_year = int(birth_year)                      # make birthyear integer for comparisons

                # 3.22 in the time span, loop through person's genres and person for each of their genres and add to dictionary
                if 1900 <= birth_year <= 2000:                     # filter for 20th century authors
                    if type(genre) is list:                        # if the writer has several genres, add once for each
                        for one_genre in genre:
                            if genre_category in one_genre.lower() or "thriller" in one_genre.lower():  # include only subgenres of the current category
                                writers_dict[f"{name} {one_genre}"] = { 
                                    "birth_year": birth_year,      
                                    "genre": one_genre 
                                }
                            observations_count += 1
                            duplicates += 1                   # count duplicates if including the writer multiple times (overcounting each writer by 1)
                    else:                                     # if the writer has 1 genre, add only once
                        if genre_category in genre.lower() or "thriller" in genre.lower():
                            writers_dict[name] = {
                                "birth_year": birth_year,      
                                "genre": genre  
                            }
                            observations_count += 1

# 4. Write to CSV file
with open(f'subgenre_results_{genre_category}.csv', 'w', encoding = 'utf-8') as file:
    file.write('name, birth_year, genre\n')
    for name in writers_dict:
        file.write(f'{name}, {writers_dict[name]["birth_year"]}, {writers_dict[name]["genre"]}\n')

# 5. Count how many instances of each genre we have right now
genre_count = Counter()
for writer in writers_dict:
    writer_info = writers_dict[writer]
    genre = writer_info["genre"]
    if genre not in genre_count:
        genre_count[genre] = 1
    else:
        genre_count[genre] += 1

print(genre_count)

