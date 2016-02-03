/*Maxwell Abrams DBS Assignment 1*/
/*Problem 1:*/
create table Artist (Name varchar(30) PRIMARY KEY, Type varchar(6), Country varchar(30));

create table Album (Title varchar(30), Artist varchar(30), Year numeric(4), Type varchar(11), Rating numeric(1), PRIMARY KEY(Title,Artist),FOREIGN KEY(Artist) REFERENCES Artist(Name));

create table Tracklist(Album_Title varchar(30), Album_Artist varchar(30), Track_No numeric(2,0), Track_Title varchar(30), Track_Length time, PRIMARY KEY (Album_Title, Album_Artist, Track_No), FOREIGN KEY(Album_Title,Album_Artist) REFERENCES  Album(Title,Artist));

insert into Artist values ('Justin Timberlake','PERSON','United States');
insert into Artist values ('will.i.am','PERSON','United States');
insert into Artist values ('Maroon 5','BAND','United States');
insert into Artist values ('Clean Bandit','BAND','United Kingdom');
insert into Artist values ('Enrique Iglesias','PERSON','Spain');

insert into Album values ('FutureSex/LoveSounds','Justin Timberlake', 2006, 'STUDIO', 4);
insert into Album values ('#willpower','will.i.am',2013,'STUDIO',3);
insert into Album values ('Songs About Jane','Maroon 5',2002,'STUDIO',4);
insert into Album values ('New Eyes','Clean Bandit',2014,'STUDIO',3);
insert into Album values ('Vivir','Enrique Iglesias',1997,'COMPILATION',1);

insert into Tracklist values ('FutureSex/LoveSounds','Justin Timberlake',2, 'SexyBack','00:04:03');
insert into Tracklist values ('FutureSex/LoveSounds','Justin Timberlake',4, 'My Love','00:04:36');
insert into Tracklist values ('FutureSex/LoveSounds','Justin Timberlake',5, 'LoveStoned','00:07:24');
insert into Tracklist values ('FutureSex/LoveSounds','Justin Timberlake',9, 'Summer Love','00:06:24');
insert into Tracklist values ('FutureSex/LoveSounds','Justin Timberlake',10, 'Until the End ofTime','00:05:22');
insert into Tracklist values ('#willpower','will.i.am',1,'Good Morning','00:01:45');
insert into Tracklist values ('#willpower','will.i.am',2,'Hello','00:04:46');
insert into Tracklist values ('#willpower','will.i.am',3,'This Is Love','00:04:40');
insert into Tracklist values ('#willpower','will.i.am',4,'Scream & Shout','00:04:43');
insert into Tracklist values ('#willpower','will.i.am',8,'Freshy','00:04:07');
insert into Tracklist values ('Songs About Jane','Maroon 5',1,'Harder to Breathe','00:02:54');
insert into Tracklist values ('Songs About Jane','Maroon 5',2,'This Love','00:03:27');
insert into Tracklist values ('Songs About Jane','Maroon 5',3,'Shiver','00:03:00');
insert into Tracklist values ('Songs About Jane','Maroon 5',4,'She Will Be Loved','00:04:18');
insert into Tracklist values ('Songs About Jane','Maroon 5',5,'Tangled','00:03:18');
insert into Tracklist values ('New Eyes','Clean Bandit',1,'Real Love','00:03:39');
insert into Tracklist values ('New Eyes','Clean Bandit',2,'Come Over','00:03:43');
insert into Tracklist values ('New Eyes','Clean Bandit',3,'Rather Be','00:03:47');
insert into Tracklist values ('New Eyes','Clean Bandit',4,'Show Me Love','00:03:26');
insert into Tracklist values ('New Eyes','Clean Bandit',5,'Extraordinary','00:04:16');
insert into Tracklist values ('Vivir','Enrique Iglesias',2,'Al despertar', '00:04:14');
insert into Tracklist values ('Vivir','Enrique Iglesias',3,'Lluvia cae','00:04:34');
insert into Tracklist values ('Vivir','Enrique Iglesias',4,'Tu vacio','00:03:56');
insert into Tracklist values ('Vivir','Enrique Iglesias',6,'Miente','00:03:36');
insert into Tracklist values ('Vivir','Enrique Iglesias',9,'El muro','00:04:14');

/*Problem 2:*/
/*1)*/ 
SELECT Artist 
FROM Album A1 
WHERE A1.type='COMPILATION' 
AND EXISTS 
    (
    SELECT * 
    FROM Album A2 
    WHERE A2.Type='LIVE' 
    AND A1.Year = A2.Year 
    AND A1.Artist=A2.Artist
    );

/*2)*/ 
SELECT DISTINCT Artist 
FROM Album A1 
WHERE Artist NOT IN 
    ( 
    SELECT Artist 
    FROM Album A2 
    WHERE A2.Type='LIVE' 
    OR A2.Type='COMPILATION' 
    AND A1.Artist=A2.Artist
    );

/*3)*/ 
SELECT Title 
FROM Album A1 
JOIN Artist ON A1.Artist=Artist.Name 
WHERE Artist.type='BAND' 
AND EXISTS
    (
    SELECT * 
    FROM Album A2 
    WHERE A1.Rating>A2.Rating 
    AND A1.year>A2.Year 
    AND A1.Artist=A2.Artist
    );

/*4*/ 
SELECT A1.Title 
FROM Album A1 
JOIN Artist ON A1.Artist=Artist.Name 
WHERE Artist.Country='United Kingdom' 
OR Artist.Country='Scotland' 
OR Artist.Country='Wales' 
OR Artist.Country='Northern Ireland' 
AND A1.Type='LIVE' 
AND A1.Rating>(
    SELECT AVG(Rating) 
    FROM Album A2 
    WHERE A1.Year=A2.Year 
    Group By A1.Year
    );

/*5)*/ 
SELECT DISTINCT T1.Track_Title, A1.Title as Album_Title, A1.Artist 
FROM Album A1 
JOIN Tracklist T1 ON T1.Album_Artist=A1.Artist 
WHERE T1.Track_Length<'00:02:34' 
AND A1.Rating>=4 
AND A1.Year>1994;

/*6)*/ 
SELECT AVG(sum) 
FROM 
    (
    SELECT SUM(T1.Track_Length) 
    FROM Tracklist T1 
    JOIN Album A1 ON A1.Artist=T1.Album_Artist AND T1.Album_Title=A1.Title 
    WHERE A1.Year>=1990 
    AND A1.Year<2000 
    GROUP BY T1.Album_Title 
    HAVING COUNT(T1.Track_No)>=10
    ) 
AS sum;

/*7)*/ 
SELECT DISTINCT A1.Artist 
FROM ALBUM A1 
WHERE Artist NOT IN 
    (
    SELECT A2.Artist 
    FROM Album A2, Album A3 
    WHERE A2.Type='STUDIO' 
    AND A3.Type='STUDIO' 
    AND A2.Artist=A3.Artist 
    AND 
        (
        (A2.Year-A3.Year>4) 
        OR (A3.Year-A2.Year>4)
        )
   );

/*8)*/ 
SELECT DISTINCT A1.Artist 
FROM Album A1 
WHERE 
    (
    SELECT COUNT(*) 
    FROM Album A2 
    WHERE 
        (
        A2.Type='LIVE' 
        OR A2.Type='Compilation'
        ) 
    AND A2.Artist=A1.Artist 
    GROUP BY A2.Artist
    )
>
    (
    SELECT COUNT(*) 
    FROM Album A3 
    WHERE A3.TYPE='STUDIO' 
    AND A3.Artist=A1.Artist 
    GROUP BY A3.Artist
    );

/*9)*/ 
SELECT A1.Title, SUM(T1.Track_Length) 
FROM Album A1 
JOIN Tracklist T1 On A1.Title=T1.Album_Title AND A1.Artist=T1.Album_Artist 
WHERE Album_Title IN 
    (
    SELECT T2.Album_Title
    FROM Tracklist T2 
    GROUP BY T2.Album_Title 
    HAVING MAX(T2.Track_No)=COUNT(T2.Track_NO)
    )
GROUP BY A1.Title;

/*10)*/ 
SELECT DISTINCT Artist 
FROM Album 
WHERE Artist IN 
(
    SELECT A1.Artist 
    FROM Album A1 
    WHERE A1.Type='STUDIO' 
    GROUP BY A1.Artist 
    HAVING COUNT(A1.Type)>=3
) 
AND Artist IN
(
     SELECT A2.Artist 
     FROM Album A2 
     WHERE A2.Type='LIVE' 
     GROUP BY A2.Artist 
     HAVING COUNT(A2.Type)>=2
)
AND Artist IN 
(
    SELECT A3.Artist
    FROM Album A3
    WHERE A3.Type='COMPILATION' 
    GROUP BY A3.Artist 
    HAVING COUNT(A3.Type)>=1
)
AND Artist NOT IN
(
    SELECT A4.Artist 
    FROM Album A4 
    WHERE A4.Rating<3
);

/*11)*/  
SELECT COUNT(*) 
FROM 
    (
    SELECT DISTINCT Name 
    FROM Album A1 
    JOIN Artist ON A1.Artist=Artist.Name 
    WHERE Artist.Type='BAND' 
    AND Artist.Country='United States' 
    AND EXISTS 
        (
        Select A2.Year 
        FROM Album A2 
        WHERE A1.Artist=A2.Artist 
        AND A2.Year<A1.Year
        )
     ) 
AS sumBand;

/*12)*/ 
SELECT F1.Artist AS Artist, cast((C1/C2 * 100) as numeric(5,2)) as P 
FROM 
    (
        (
        SELECT A2.Artist AS ART1, count(*) AS C1 
        FROM Album A2 
        WHERE A2.Rating <3 
        GROUP BY A2.Artist
        ) 
    AS count1 
    FULL JOIN 
        (
        SELECT A2.Artist,count(*) AS C2 
        FROM Album A2 GROUP BY A2.Artist
        ) 
    AS count2 
    ON count2.Artist=count1.ART1
    ) 
AS F1 ORDER BY P;

/*13)*/  
SELECT F1.Artist 
FROM 
    (
    SELECT DISTINCT Artist 
    FROM Album A1
    JOIN Artist ON A1.Artist=Artist.Name 
    WHERE A1.Type='STUDIO' 
    ) 
AS F1
WHERE
    (
    F1.Country=A2.Country
    AND Artist!=A2.Artist
    OR F1.Country IN
        (
        SELECT Country
        FROM Artist join Album A2 on name=A2.Artist
        WHERE A2.Type='STUDIO'
        GROUP BY Country
        HAVING count(DISTINCT Artist)=1
        )
    );

/*14)*/ 
SELECT A1.Title as Higher, A2.TITLE as Lower 
FROM Album A1 
JOIN Artist Art1 ON A1.Artist=Art1.Name, Album A2 JOIN Artist Art2 ON A2.Artist=Art2.Name 
WHERE Art1.Country!=Art2.Country 
AND A1.Year=A2.Year 
AND A1.Rating>A2.Rating;


/*15)*/ 
SELECT CountTrack.Album_Title, (A1.Rating/count) AS ratio 
FROM 
    (
    Album A1 JOIN
        (
        SELECT T1.Album_Title, count(T1.Track_No) AS count 
        FROM Tracklist T1 
        GROUP BY T1.Album_Title
        )
     As CountTrack ON CountTrack.Album_Title=A1.Title
    ) 
ORDER BY ratio DESC;


