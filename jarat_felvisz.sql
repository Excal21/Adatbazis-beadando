insert into Jarat (Jaratszam, Megnevezes, Honnan, Hova, Indulas, Erkezes, Tavolsag, Menetido, Ar, Helyjegy, VonalUzemelteto, VonatTipus)
values (31916, 'szem�lyvonat', 'P�pa', 'Csorna', '17:39', '18:42',37, CONCAT(FLOOR(DATEDIFF(second, '17:39', '18:42') / 3600), ' �ra ', FLOOR((DATEDIFF(second, '17:39', '18:42') % 3600) / 60), ' perc '), 560, 0, 2, 'M46')