# TMDb Movie Metadata App — Database Notes

This document explains the **design reasoning, data sources, and rules** for the TMDb Movie Metadata App.  
It’s intended for portfolio reviewers and interviewers to understand **why** the database is structured this way, without showing every single column.

---

## 1️⃣ Purpose

The database is designed to store metadata for movies and TV series obtained from **TMDb**, including:

- Movie/TV details (title, overview, release date, runtime, language, poster/backdrop images)  
- Genres  
- Cast and crew members with roles  
- Ratings (currently TMDb source)  

The design ensures:

- Scalable ingestion of TMDb data  
- Many-to-many relationships between movies, genres, cast, and crew  
- Compliance with TMDb 6-month caching rule via `lastRefreshedAt` timestamps  
- Flexibility for adding new sources or content types in the future  

---

## 2️⃣ Core Models

### Movie
- Stores TMDb movies or TV shows  
- Includes metadata and `lastRefreshedAt` for TMDb compliance  
- Relations:
  - Genres (many-to-many)  
  - Cast (many-to-many via `MovieCast`)  
  - Crew (many-to-many via `MovieCrew`)  
  - Ratings (one-to-many)

### Genre
- Movie/TV genres (e.g., Comedy, Drama)  
- Usually synced from TMDb once; `lastRefreshedAt` ensures freshness

### Person
- Represents cast or crew members  
- TMDb ID ensures uniqueness  
- Relations:
  - `MovieCast` for cast roles  
  - `MovieCrew` for crew roles  
- `lastRefreshedAt` ensures metadata stays current

### MovieCast
- Junction table connecting Movies → Cast  
- Stores character name and order

### MovieCrew
- Junction table connecting Movies → Crew  
- `job` describes the role (Director, Writer, Producer, etc.)

### Rating
- Stores ratings from TMDb  
- `lastRefreshedAt` ensures compliance with 6-month cache rule

---

## 3️⃣ Enums

### ContentType
- `MOVIE` — Standard movie  
- `TV` — TV series / episodic content

### CrewJob
- `DIRECTOR`, `WRITER`, `PRODUCER`, `CINEMATOGRAPHER`, `EDITOR`, `COMPOSER`  
- Used to structure crew roles

### RatingSource
- Currently only `TMDB`  
- Designed to allow future rating sources

---

## 4️⃣ Design Notes / Decisions

- **TMDb Compliance:** Every table with TMDb metadata includes `lastRefreshedAt`  
- **Relations:** Junction tables use composite primary keys to enforce uniqueness  
- **Scalability:** Easy to add new movies, genres, cast, crew, or ratings without schema redesign  
- **Portfolio / Interview Focus:** Highlights systems thinking and real-world considerations (scalable ingestion, data freshness, normalization, enums)

---

> For exact column types, constraints, and field mappings, see `prisma/schema.prisma`.  
> This file focuses on **why the DB is structured this way**, not the technical minutiae.
