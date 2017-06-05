CREATE DATABASE Projekt_1
Use Projekt_1
CREATE TABLE DaneSamochodow
(
IdSamochodu INT NOT NULL PRIMARY KEY, Marka VARCHAR(30) NOT NULL,Model VARCHAR(30) NOT NULL, Pojemność INT, IloscMiejsc INT, NrRejestracyjny VARCHAR(8) NOT NULL, RokProdukcji DATETIME
)

CREATE TABLE RodzajePaczek
(
IdRodzaju INT NOT NULL PRIMARY KEY, Nazwa VARCHAR(30) NOT NULL, Oznaczenie VARCHAR(10) NOT NULL
)

CREATE TABLE PrzydzialSamochodow
(
IdZespolu INT NOT NULL PRIMARY KEY, NazwaObszaru VARCHAR(60) NOT NULL, IloscDowiezionychPaczek INT NOT NULL, Prowizja MONEY NOT NULL, IdSamochodu INT REFERENCES DaneSamochodow(IdSamochodu)
)

CREATE TABLE Adresy
(
IdAdresu INT NOT NULL PRIMARY KEY, Miejscowosc VARCHAR(30) NOT NULL, Ulica VARCHAR(30) NOT NULL, NrDomu SMALLINT NOT NULL,
)

CREATE TABLE Osoby
(
Pesel VARCHAR(13) NOT NULL PRIMARY KEY, Imie VARCHAR(30) NOT NULL, Nazwisko VARCHAR(30) NOT NULL,  IdAdresu INT NOT NULL REFERENCES Adresy(IdAdresu)
)

CREATE TABLE Pracownicy
(
IdOsoby VARCHAR(13) NOT NULL REFERENCES Osoby(Pesel), DataZatrudnienia DATE NOT NULL, Pensja MONEY NOT NULL, PrawoJazdy BIT NOT NULL, IdZespolu INT NOT NULL REFERENCES PrzydzialSamochodow(IdZespolu)
)

CREATE TABLE Przesylki
(
IdPrzesylki INT NOT NULL PRIMARY KEY, Rodzaj INT NOT NULL REFERENCES RodzajePaczek(IdRodzaju), Data DATETIME NOT NULL, IdAdresu INT NOT NULL REFERENCES Adresy(IdAdresu), KosztPaczki MONEY
)

CREATE TABLE Zleceniodawcy
(
IdOsoby VARCHAR(13) NOT NULL REFERENCES Osoby(Pesel), IdZgloszenia INT NOT NULL REFERENCES Przesylki(IdPrzesylki), DodatkoweInformacje VARCHAR(400) NOT NULL,
)


-- Dodawanie danych

INSERT INTO Adresy VALUES (1, 'Bobowa', 'Grunwaldzka', 84), (2, 'Nowy Sacz', '3 Maja', 12), (3, 'Gorlice', 'Lwowska', 5), (4, 'Kraków', 'Rynek', 10);

INSERT INTO Osoby VALUES (93111712133, 'Jan', 'Kowalski', 1), (93111212133, 'Maciek', 'Borkowski', 2), (91111742133, 'Adam', 'Poniatowski', 3), (83111712133, 'Mariola', 'Katra', 4);

INSERT INTO DaneSamochodow VALUES (1, 'Fiat', 'Ducato', 3000, 3, 'KGR44AA', 2008), (2, 'Iveco', 'Daily', 3500, 2, 'KR G4DS', 2010);

INSERT INTO PrzydzialSamochodow VALUES (1, 'KGR', 1234, 200, 1), (2, 'KRA', 200, 200, 2),(3, 'KNS', 100, 100, NULL) ;

INSERT INTO Pracownicy VALUES (93111712133, '2015-01-01', 3000, 1, 1), (93111212133, '2013-01-01', 4000, 1, 2);

INSERT INTO RodzajePaczek VALUES (1, 'ZWYKLA', 'STD'), (2, 'ZWYKLA UBEZP', 'STDUB'), (3, 'POBRANIOWA', 'POB'), (4, 'SZYBKA', 'PR1');

INSERT INTO Przesylki VALUES (1, 1, '2017-05-05', 3, 40),(2, 4, '2017-03-05', 4, 30);

INSERT INTO Zleceniodawcy VALUES (91111742133, 1, 'Firma abc'), (83111712133, 2, 'Firma xyz');


-- ODCZYT DANYCH

SELECT * FROM Przesylki;

-- WIDOKI