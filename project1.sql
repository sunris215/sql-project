CREATE DATABASE Projekt_1

Use Projekt_1
CREATE TABLE DaneSamochodow
(
IdSamochodu INT NOT NULL PRIMARY KEY, Marka VARCHAR(30) NOT NULL,Model VARCHAR(30) NOT NULL, Pojemność INT,
	IloscMiejsc INT, NrRejestracyjny VARCHAR(8) NOT NULL, RokProdukcji DATETIME
)

CREATE TABLE RodzajePaczek
(
IdRodzaju INT NOT NULL PRIMARY KEY, Nazwa VARCHAR(30) NOT NULL, Oznaczenie VARCHAR(10) NOT NULL
)

CREATE TABLE PrzydzialSamochodow
(
IdZespolu INT NOT NULL PRIMARY KEY, NazwaObszaru VARCHAR(60) NOT NULL, IloscDowiezionychPaczek INT NOT NULL,
	Prowizja MONEY NOT NULL, IdSamochodu INT REFERENCES DaneSamochodow(IdSamochodu)
)

CREATE TABLE Adresy
(
IdAdresu INT NOT NULL PRIMARY KEY, Miejscowosc VARCHAR(30) NOT NULL, Ulica VARCHAR(30) NOT NULL,
	NrDomu SMALLINT NOT NULL,
)

CREATE TABLE Osoby
(
Pesel VARCHAR(13) NOT NULL PRIMARY KEY, Imie VARCHAR(30) NOT NULL, Nazwisko VARCHAR(30) NOT NULL,
	IdAdresu INT NOT NULL REFERENCES Adresy(IdAdresu)
)

CREATE TABLE Pracownicy
(
IdOsoby VARCHAR(13) NOT NULL REFERENCES Osoby(Pesel), DataZatrudnienia DATE NOT NULL, Pensja MONEY NOT NULL,
	PrawoJazdy BIT NOT NULL, IdZespolu INT NOT NULL REFERENCES PrzydzialSamochodow(IdZespolu)
)

CREATE TABLE Przesylki
(
IdPrzesylki INT NOT NULL PRIMARY KEY, Rodzaj INT NOT NULL REFERENCES RodzajePaczek(IdRodzaju), 
Data DATETIME NOT NULL, IdAdresu INT NOT NULL REFERENCES Adresy(IdAdresu), KosztPaczki MONEY,
	Dostarczona BIT NOT NULL DEFAULT (0)
)

CREATE TABLE Zleceniodawcy
(
IdOsoby VARCHAR(13) NOT NULL REFERENCES Osoby(Pesel), IdZgloszenia INT NOT NULL REFERENCES Przesylki(IdPrzesylki),
	DodatkoweInformacje VARCHAR(400) NOT NULL,
)

----------------------------------------------------------------------------------

-- Dodawanie danych

INSERT INTO Adresy VALUES (1, 'Bobowa', 'Grunwaldzka', 84), (2, 'Nowy Sacz', '3 Maja', 12),
	(3, 'Gorlice', 'Lwowska', 5), (4, 'Kraków', 'Rynek', 10);

INSERT INTO Osoby VALUES (93111712133, 'Jan', 'Kowalski', 1), (93111212133, 'Maciek', 'Borkowski', 2),
	(91111742133, 'Adam', 'Poniatowski', 3), (83111712133, 'Mariola', 'Katra', 4);

INSERT INTO DaneSamochodow VALUES (1, 'Fiat', 'Ducato', 3000, 3, 'KGR44AA', '2008-01-01'),
	(2, 'Iveco', 'Daily', 3500, 2, 'KR G4DS', '2010-01-01');

INSERT INTO PrzydzialSamochodow VALUES (1, 'KGR', 1234, 200, 1), (2, 'KRA', 200, 200, 2),(3, 'KNS', 100, 100, NULL) ;

INSERT INTO Pracownicy VALUES (93111712133, '2015-01-01', 3000, 1, 1), (93111212133, '2013-01-01', 4000, 1, 2);

INSERT INTO RodzajePaczek VALUES (1, 'ZWYKLA', 'STD'), (2, 'ZWYKLA UBEZP', 'STDUB'), (3, 'POBRANIOWA', 'POB'),
	(4, 'SZYBKA', 'PR1');

INSERT INTO Przesylki VALUES (1, 1, '2017-05-05', 3, 40, 2),(2, 4, '2017-03-05', 4, 30, 0);

INSERT INTO Zleceniodawcy VALUES (91111742133, 1, 'Firma abc'), (83111712133, 2, 'Firma xyz');

----------------------------------------------------------------------------------

------------------------------------- ODCZYT DANYCH ------------------------------

SELECT * FROM Przesylki;
SELECT * FROM DaneSamochodow;

------------------------------------- Moje widoki --------------------------------

create view WyswietlSamochoduMarkiFiat
as
	SELECT DaneSamochodow.Model, DaneSamochodow.Pojemność, DaneSamochodow.IloscMiejsc
	FROM DaneSamochodow
	WHERE Marka='Fiat'

select * from WyswietlSamochoduMarkiFiat

----------------------------------------------------------------------------------

create view WyswietlPaczki
as
	SELECT RodzajePaczek.Nazwa, RodzajePaczek.Oznaczenie
	FROM RodzajePaczek

select * from WyswietlPaczki

----------------------------------------------------------------------------------

create view WyswietlSzczegoloweDanePracownikow
as
	SELECT O.Imie, O.Nazwisko, O.Pesel, P.DataZatrudnienia, P.Pensja
	FROM Osoby O JOIN Pracownicy P
	On P.IdOsoby = O.Pesel

select * from WyswietlSzczegoloweDanePracownikow

----------------------------------------------------------------------------------

create view WyswietlZarobkiNaDanyZespol
as
	SELECT IdSamochodu, IdZespolu, (IloscDowiezionychPaczek * Prowizja) AS Zarobki
	FROM PrzydzialSamochodow

select * from WyswietlZarobkiNaDanyZespol

----------------------------------------------------------------------------------

create view WyswietlTegorocznePaczki
as
	SELECT P.IdPrzesylki, P.Dostarczona, R.Nazwa, R.Oznaczenie, P.Data
	FROM Przesylki P JOIN RodzajePaczek R
	On P.Rodzaj=R.IdRodzaju
	WHERE DATEPART(YEAR,P.Data) = DATEPART(YEAR,GETDATE())

select * from WyswietlTegorocznePaczki

----------------------------------------------------------------------------------

create view WyswietlZleceniodawcowOrazIchPrzesylki
as
	SELECT Z.IdOsoby, O.Imie, O.Nazwisko, A.Miejscowosc, A.NrDomu, P.IdPrzesylki, P.Data
	FROM Zleceniodawcy Z

	LEFT JOIN Osoby O
	ON Z.IdOsoby = O.Pesel
	JOIN Przesylki P
	ON Z.IdZgloszenia = P.IdPrzesylki
	JOIN Adresy A
	ON A.IdAdresu = O.IdAdresu

select * from WyswietlZleceniodawcowOrazIchPrzesylki

----------------------------------------------------------------------------------

create view WyswietlDochody
as
	SELECT P.KosztPaczki
	FROM Zleceniodawcy Z RIGHT JOIN Przesylki P
	ON Z.IdZgloszenia=P.IdPrzesylki
	LEFT JOIN Osoby O
	ON Z.IdOsoby = O.Pesel

select * from WyswietlDochody

----------------------------------------------------------------------------------

create view WyswietlRoczajePaczek
as
	SELECT Nazwa, Oznaczenie
	FROM RodzajePaczek

select * from WyswietlRoczajePaczek

----------------------------------------------------------------------------------


------------------------------------- PROCEDURY ----------------------------------


------------------------------------- Aktualizuje adres --------------------------

CREATE PROCEDURE Pr1
(@IdAdresu INT, @Miejscowosc nvarchar(30),  @Ulica nvarchar(30), @NrDomu INT)
AS
	UPDATE Adresy  SET Adresy.Miejscowosc=@Miejscowosc, Adresy.Ulica=@Ulica, Adresy.NrDomu=@NrDomu
	WHERE Adresy.IdAdresu=@IdAdresu

exec Pr1 1,'Nowy Sacz', 'Lwowska', 44

SELECT * FROM Adresy WHERE IdAdresu = 1;

------------------ Wyswietla samochod o pojemnosci podanej jako argument -------

Create PROCEDURE Pr2
@Pojemnosc INT
AS
	SELECT * FROM DaneSamochodow
	WHERE DaneSamochodow.Pojemność=@Pojemnosc

exec Pr2 500

----------------- Dodaje nowego zleceniodawce -----------------------------------

Create PROCEDURE Pr3
@IdOsoby INT, @IdZgloszenia INT, @DodatkoweInformacje nvarchar(400)
as
	INSERT INTO Zleceniodawcy values (@IdOsoby, @IdZgloszenia ,@DodatkoweInformacje)

exec Pr3 93111712133, 92333, 'Firma Nazwa'

----------------- Wypisuje paczki o cennie wiekszej niz podana  ---------------

CREATE PROCEDURE Pr4
(@Koszt float)
AS
	SELECT * FROM Przesylki
	WHERE Przesylki.KosztPaczki>@Koszt

exec  Pr4 5

------------------------------------- FUNCKJE ---------------------------------

---------------- Wypisuje imie i nazwisko osoby danym id pracownika -----------

create function fun1 -- todo Dawid can you chceck it?
(@IdOsoby int)
returns table
AS
return
(
	select O.Imie as Imie, O.Nazwisko as Nazwisko
	from Pracownicy P join Osoby O
	on P.IdOsoby=O.Pesel
	where P.IdOsoby=@IdOsoby
)

select * from fun1 (1)


---------------- Wypisuje informacje o zleceniodawcy po poddanymn id -----------
create function fun2 -- todo Dawid can you chceck it?
	(@IdZleceniodawcy int)
	returns table
	AS
	return
	(
	select Z.IdOsoby as ID, Z.DodatkoweInformacje as DodatkoweInformacje
	from Zleceniodawcy Z
	where P.IdOsoby=@IdOsoby
	)
select * from fun2 (1)

------------------------------------- TRIGGERY ---------------------------------

-- Opis: trigger zabezpiecza bazę przed cofaniem "licznika" dowiezionych paczek
	-- w tabeli "PrzydzialSamochodow"

CREATE TRIGGER T1 ON PrzydzialSamochodow AFTER UPDATE
AS
IF UPDATE(IloscDowiezionychPaczek)
BEGIN
DECLARE @StaraIloscDowPaczek INT
DECLARE @NowaIloscDowPaczek INT
SET @StaraIloscDowPaczek = (SELECT IloscDowiezionychPaczek FROM DELETED)
SET @NowaIloscDowPaczek = (SELECT IloscDowiezionychPaczek FROM inserted)
IF @StaraIloscDowPaczek >= @NowaIloscDowPaczek
	BEGIN
		ROLLBACK
		RAISERROR('Liczba dowiezionych paczek musi byc wieksza od poprzedniej ! ', 16,1)
	END
END


UPDATE PrzydzialSamochodow SET IloscDowiezionychPaczek = 2445 WHERE IdZespolu = 1;


-- Opis: trigger zabezpiecza przed aktualizacja wieku samochodow 
-- Wraz z triggerem został stworzony Check Constraint dla Insertów - wymagany
	-- jest wiek młodszy niż 17 lat
 
CREATE TRIGGER T2 ON DaneSamochodow AFTER UPDATE
AS
IF UPDATE(RokProdukcji)
BEGIN
DECLARE @StaryRokProdukcji INT
DECLARE @NowyRokProdukcji INT
SET @StaryRokProdukcji = (SELECT DATEPART(YEAR,RokProdukcji) FROM DELETED)
SET @NowyRokProdukcji = (SELECT DATEPART(YEAR,RokProdukcji) FROM inserted)
IF @NowyRokProdukcji <> @StaryRokProdukcji
	BEGIN
		ROLLBACK
		RAISERROR('Nie wolno aktualizowac roku produkcji!', 16,1)
	END
END

-- todo: sprawdzić to ALTER TABLE na czystej bazie 

ALTER TABLE DaneSamochodow
ADD CONSTRAINT C_DaneSamochodow CHECK (RokProdukcji >= '2000-01-01')

INSERT INTO DaneSamochodow VALUES (5, 'Iveco', 'Daily', 2500, 2, 'KR A4D5', '1993-01-01');

UPDATE DaneSamochodow SET RokProdukcji = '2008-01-01' WHERE IdSamochodu = 1;


-- Opis: trigger sprawdzajacy poprawnosc nr PESEL

CREATE TRIGGER T3 ON Osoby AFTER INSERT
AS
BEGIN
IF Exists(Select * From inserted Where Len(Pesel) <> 11) 
	BEGIN
		ROLLBACK
		RAISERROR('Niepoprawny PESEL!', 16,1)
	END
END


INSERT INTO Osoby VALUES ('111111111112', 'Andrzej', 'Nowacki', 1);

SELECT * FROM Osoby


--todo
--todo zrobic opis,
-- sprawdzic czy dziala wszsystko,
-- sprawdzic czy wszystko z listy jest zrobione