# KPABD MongoDB
###### tags: `KPABD`

## Zadanie 1

```=nosql
cmd> mongo -> połącz się z serwerem na tym atlasie
mongod --dbpath **lokacja*
show dbs
use library
show collections <- pokazuje kolekcje
db.*Kolekcja*.drop() <- usuwa kolekcję
```

## Zadanie 2
```=nosql
db.createCollection("Ksiazka")
db.createCollection("Czytelnik")

db.Ksiazka.save({
    _id: 1,
    ISBN: "83-246-0279-8",
    Tytul: "Microsoft Access. Podrecznik administratora",
    Autor: "Helen Feddema",
    RokWydania: 2006,
    Cena: 69,
    Egzemplarze:
    [
        {
            Sygnatura: "S0001"
        }
    ]
})

db.Ksiazka.save({
    _id: 2,
    ISBN: "83-246-0653-X",
    Tytul: "SQL Server 2005. Programowanie. Od podstaw",
    Autor: "Robert Vieira",
    RokWydania: 2007,
    Cena: 97,
    Egzemplarze:
    [
        {
            Sygnatura: "S0002"
        },
        {
            Sygnatura: "S0003"
        }
    ]
})

db.Czytelnik.save({
    _id: 1,
    PESEL: "55101011111",
    Nazwisko: "Kowalski",
    Miasto: "Wroclaw",
    DataUrodzenia: new Date("1955-10-10"),
    OstatnieWypozyczenie: new Date("2020-02-01"),
    Wypozyczenia:
    [
        {
            SygnaturaEgzemplarza: "S0001",
            Data: new Date("2020-02-01"),
            LiczbaDni: 12
        },
        {
            SygnaturaEgzemplarza: "S0003",
            Data: new Date("2020-01-05"),
            LiczbaDni: 20
        }
    ]
})

db.Czytelnik.save({
    _id: 2,
    PESEL: "60101033333",
    Nazwisko: "Maliniak",
    Miasto: "Wroclaw",
    DataUrodzenia: new Date("1960-10-10"),
    OstatnieWypozyczenie: new Date("2020-01-21"),
    Wypozyczenia:
    [
        {
            SygnaturaEgzemplarza: "S0002",
            Data: new Date("2020-01-21"),
            LiczbaDni: 45
        },
        {
            SygnaturaEgzemplarza: "S0001",
            Data: new Date("2020-01-13"),
            LiczbaDni: 7
        }
    ]
})
```

## Zadanie 3
```=nosql
db.runCommand( {
   collMod: "Ksiazka",
   validator: { $jsonSchema: {
      bsonType: "object",
      required: [ "ISBN", "Tytul", "Autor", "RokWydania", "Cena", "Egzemplarze" ],
      properties: {
         ISBN: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         Tytul: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         Autor: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         RokWydania: {
            bsonType: "int",
            minimum: 1900,
            maximum: 2030,
            description: "must be an int between 1900 and 2030 and is required"
         },
         Cena: {
            bsonType: "int",
            description: "must be an int and is required"
         },
         Egzemplarze: {
             bsonType: "object",
             required: [ "Sygnatura" ],
             properties: {
                 Sygnatura: {
                     bsonType: "string",
                     description: "must be a string and is required"
                     }
             }
         }
      }
   } },
   validationLevel: "moderate"
} )


db.runCommand( {
   collMod: "Czytelnik",
   validator: { $jsonSchema: {
      bsonType: "object",
      required: [ "PESEL", "Nazwisko", "Miasto", "Wroclaw", "DataUrodzenia" ],
      properties: {
         PESEL: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         Nazwisko: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         Miasto: {
            bsonType: "string",
            description: "must be a string and is required"
         },
         DataUrodzenia: {
            bsonType: "date",
            description: "must be a date and is required"
         }
         
      }
   } },
   validationLevel: "moderate"
} )
```

db.Ksiazka.update({_id:1}, {$set:{RokWydania:2006}}) <- sprawdzanie czy poprawne?

## Zadanie 4
db.Ksiazka.find().sort({RokWydania:-1,title:1}).skip(2).limit(2);
db.Czytelnik.find({"Wypozyczenia.SygnaturaEgzemplarza": "S0002"})

## Zadanie 5
start "A" mongod --dbpath C:\Users\Dell\Documents\Uni\KPABD\Lista_5\Replication\db1 --port 10000 --replSet "demo"

reszta jak na prezentacji