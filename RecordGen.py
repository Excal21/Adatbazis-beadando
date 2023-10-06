import random as r
from datetime import date, timedelta

def GenIDs(n : int):
    id_set = set()
    while len(id_set) != n:
        id : str = ''
        for i in range(6):
            id += str(r.randint(0, 9))
        id += chr(r.randint(65, 90))
        id += chr(r.randint(65, 90))

        id_set.add(id)

    with open('ids.txt', 'w', encoding='UTF-8') as file:
        for i in range(n):
            file.write('\'' + list(id_set)[i] + '\'\n')
    
    return list(id_set)

def GenNames(n : int):
    lastname : list = ['Varga', 'Szabó', 'Kovács', 'Horváth', 'Bese', 'Kocsis', 'Gaál', 'Bíró', 'Boros', 'Kiss', 'Mészáros', 'Vadász', 'Nagy', 'Szalay',
                        'Cziráki', 'Babits', 'Törös', 'Takács', 'Molnár', 'Németh', 'Csendes', 'Szalai', 'Tóth', 'Fekete', 'Fehér', 'Pap', 'Papp', 'Hegyi',
                        'Farkas', 'Juhász', 'Király', 'Vass', 'Hegedűs', 'Tordai', 'Bogdán', 'Törőcsik', 'Salamon', 'Sipos', 'Bálint', 'Lengyel', 'Szűcs',
                        'Paál', 'Vincze', 'Balogh', 'Simon', 'Kun', 'Kozma', 'Győri']

    firstname : list = ['Anna', 'Péter', 'Katalin', 'János', 'Mária', 'István', 'Zsuzsanna', 'Gábor', 'Judit', 'András', 'Erzsébet', 'László', 'Éva', 'Ferenc',
                       'Borbála', 'Gergő', 'Gabriella', 'Sándor', 'Réka', 'Norbert', 'Orsolya', 'Tamás', 'Erika', 'György', 'Emese', 'Zoltán', 'Eszter', 'Róbert',
                        'Laura', 'Levente', 'Veronika', 'Viktor', 'Krisztina', 'Olivér', 'Boglárka', 'Balázs', 'Krisztián', 'Szilvia', 'Richárd']

    name_list : list = []
    with open('names.txt', 'w', encoding='UTF-8') as file:
        for i in range(n):
            name = r.choice(lastname) + ' ' + r.choice(firstname)
            name_list.append(name)
            file.write('\'' + name_list[i] + '\'\n')
    return name_list

def GenDates(n : int, min_age : int) -> list:
    births = []
    with open('births.txt', 'w', encoding='UTF-8') as file:
        for i in range(n):
            day = r.randint(1,28)
            month = r.randint(1,12)
            year = r.randint(1940, 2022-min_age)
            births.append(date(year , month, day))
            file.write('\'' + births[i].isoformat() + '\'\n')
    return births

def GenRecords(n : int):
    records = []
    
    ids = GenIDs(n)
    names = GenNames(n)
    births = GenDates(n, 14)

    now = date.today()

    for i in range(n):
        record = '(\'' + ids[i] +'\',\'' + names[i] + '\',\'' + births[i].isoformat() + '\',\'' 
        if int((now-births[i]).days)/365 < 25:
            record += '1'
        elif int((now-births[i]).days)/365 >= 65:
            record += '4'
        else:
            record += r.choice(['2','3','5'])
        record += '\')'
        if(i < n-1): record += ','
        records.append(record)

    return records

def GenInsertInto(n : int):
    records = GenRecords(n)

    with open('records.txt', 'w', encoding='UTF-8') as file:
        file.write('INSERT INTO Vasut.dbo.VasarloAdat(SzigSzam,Nev,SzulDatum,Kedvezmeny) VALUES\n')
        file.writelines( [ line + '\n' for line in records ] )
        file.write(';')

def main():
    GenInsertInto(10)


if __name__ == '__main__':
    main()