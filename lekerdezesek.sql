/* 1. H�ny helyjegyk�teles j�rat szerepel az adatb�zisban? */
SELECT COUNT(*) AS 'HelyjegykotelesDb'
FROM Jarat
WHERE Helyjegy = 1;

/* 2. Melyek az 50%-os kedvezm�nyek? */
SELECT Tipus AS '50%Kedvezmenyek'
FROM Kedvezmeny
WHERE EngedmenySzazalek = 50;

/* 3. A Stadler FLIRT t�pus� motorvonatoknak mekkora az �tlagos menetideje? */
SELECT AVG(CAST(DATEDIFF(mi,Indulas,Erkezes) AS float)) AS 'AtlagMenetidoPercben'
FROM Jarat j
INNER JOIN VonatAdat va
ON va.Id = j.VonatTipus
WHERE va.Megnevezes = 'Stadler FLIRT motorvonat';

/* 4. H�ny fiatal (<30 �v) vett ig�nybe 90%-os kedvezm�nyt? */
SELECT COUNT(*) AS 'Fiatal90%Kedvezmeny'
FROM VasarloAdat va
INNER JOIN Kedvezmeny k
ON k.Id = va.Kedvezmeny
WHERE k.EngedmenySzazalek = 90 AND DATEADD(yy,30,va.SzulDatum) > GETDATE();

/* 5. V�g�llom�st�l v�g�llom�sig �tlagosan mennyibe ker�lnek az alacsony padl�s szerelv�nnyel indul� j�ratok? */
SELECT AVG(Ar) AS 'AlacsonyPadlosAtlagar'
FROM Jarat j
INNER JOIN VonatAdat va
ON va.Id = j.VonatTipus
WHERE Alacsony = 1;

/* 6. List�zza ki azokat a j�ratokat, amik meg�llnak Csorn�n! */
SELECT j.Jaratszam, j.Megnevezes, j.Honnan, j.Hova, j.Indulas, j.Erkezes, j.Tavolsag, j.Menetido, j.Ar,
CASE j.Helyjegy
	WHEN 0 THEN 'nem'
	WHEN 1 THEN 'igen'
	END AS 'HelyjegyKoteles'
FROM Jarat j
INNER JOIN KoztesMegallo km
ON km.Jaratszam = j.Jaratszam
INNER JOIN Megallok m
ON m.AllomasKod = km.AllomasKod
WHERE m.Megnevezes = 'Csorna';

/* 7. Melyik meg�ll�kn�l �llnak meg (sorrend szerint) a Gy�r �s Kaposv�r k�z�tt k�zleked� vonatok? */
SELECT m.Megnevezes AS 'GyorKaposvarMegallok'
FROM Megallok m
INNER JOIN KoztesMegallo km
ON km.AllomasKod = m.AllomasKod
INNER JOIN Jarat j
ON j.Jaratszam = km.Jaratszam
WHERE j.Honnan = 'Gy�r' AND j.Hova = 'Kaposv�r'
GROUP BY m.Megnevezes, Sorrend
ORDER BY Sorrend;

/* 8. Melyik �llom�sok �rintettek v�g�nyz�rral j�r� munk�latokban? */
SELECT m.Megnevezes AS 'VaganyZarbanErintottMegallok'
FROM Megallok m
INNER JOIN KoztesMegallo km
ON km.AllomasKod = m.AllomasKod
INNER JOIN Jarat j
ON j.Jaratszam = km.Jaratszam
INNER JOIN Informacio i
ON i.Id = j.Info
WHERE i.Uzenet LIKE '%v�g�nyz�r%' AND m.Tipus = 'v�'
GROUP BY m.Megnevezes;

/* 9. Ki(k) v�s�roltak jegyet a GYSEV �ltal �zemeltetett vonalon k�zleked� j�ratokra, ahol jelenleg v�g�nyz�r van �rv�nyben? */
SELECT va.Nev AS 'GysevVaganyzarJaratRendelok'
FROM VasarloAdat va
INNER JOIN Rendeles r
ON r.Vasarlo = va.SzigSzam
INNER JOIN Jarat j
ON j.Jaratszam = r.Jarat
INNER JOIN Uzemelteto u
ON u.Id = j.VonalUzemelteto
INNER JOIN Informacio i
ON i.Id = j.Info
WHERE u.Szolgaltato = 'GYSEV' AND i.Uzenet LIKE '%v�g�nyz�r%'
GROUP BY va.Nev;