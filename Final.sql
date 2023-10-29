/* 1. Hány helyjegyköteles járat szerepel az adatbázisban? */
SELECT COUNT(*) AS 'Helyjegy köteles járatok (db)'
FROM Jarat
WHERE Helyjegy = 1;

/* 2. Melyek az 50%-os kedvezmények? */
SELECT Tipus AS '50%-os Kedvezmenyek'
FROM Kedvezmeny
WHERE EngedmenySzazalek = 50;

/* 3. A Stadler FLIRT típusú motorvonatoknak mekkora az átlagos menetideje? */
SELECT AVG(CAST(DATEDIFF(mi,Indulas,Erkezes) AS float)) AS 'Átlagos menetidő (perc)'
FROM Jarat j
INNER JOIN VonatAdat va
ON va.Id = j.VonatTipus
WHERE va.Megnevezes = 'Stadler FLIRT motorvonat';

/* 4. Hány fiatal (<30 év) vett igénybe 90%-os kedvezményt? */
SELECT COUNT(*) AS 'Fiatalok 90% kedvezménnyel'
FROM VasarloAdat va
INNER JOIN Kedvezmeny k
ON k.Id = va.Kedvezmeny
WHERE k.EngedmenySzazalek = 50 AND DATEADD(yy,30,va.SzulDatum) > GETDATE();

/* 5. Végállomástól végállomásig átlagosan mennyibe kerülnek az alacsony padlós szerelvénnyel induló járatok?
(végállomástól végállomásig)*/
SELECT AVG(Ar) AS 'Alacsony padlós vonatok átlagára'
FROM Jarat j
INNER JOIN VonatAdat va
ON va.Id = j.VonatTipus
WHERE Alacsony = 1;

/* 6. Listázza ki azokat a járatokat, amik megállnak Csornán! */
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

/* 7. Melyik megállóknál állnak meg (sorrend szerint) a Gyõr és Kaposvár között közlekedõ vonatok? */
SELECT m.Megnevezes AS 'Győr-Kaposvár megállók'
FROM Megallok m
INNER JOIN KoztesMegallo km
ON km.AllomasKod = m.AllomasKod
INNER JOIN Jarat j
ON j.Jaratszam = km.Jaratszam
WHERE j.Honnan = 'Győr' AND j.Hova = 'Kaposvár'
GROUP BY m.Megnevezes, Sorrend
ORDER BY Sorrend;

/* 8. Melyik állomások érintettek vágányzárral járó munkálatokban? */
SELECT m.Megnevezes AS 'Vágányzárban érintett megállók'
FROM Megallok m
INNER JOIN KoztesMegallo km
ON km.AllomasKod = m.AllomasKod
INNER JOIN Jarat j
ON j.Jaratszam = km.Jaratszam
INNER JOIN Informacio i
ON i.Id = j.Info
WHERE i.Uzenet LIKE '%vágányzár%' AND m.Tipus = 'vá'
GROUP BY m.Megnevezes;

/* 9. Ki(k) vásároltak jegyet a GYSEV által üzemeltetett vonalon közlekedõ járatokra, ahol jelenleg vágányzár van érvényben? */
SELECT va.Nev AS 'GYSEV-es vágányzárban érintett utasok'
FROM VasarloAdat va
INNER JOIN Rendeles r
ON r.Vasarlo = va.SzigSzam
INNER JOIN Jarat j
ON j.Jaratszam = r.Jarat
INNER JOIN Uzemelteto u
ON u.Id = j.VonalUzemelteto
INNER JOIN Informacio i
ON i.Id = j.Info
WHERE u.Szolgaltato = 'GYSEV' AND i.Uzenet LIKE '%vágányzár%'
GROUP BY va.Nev;