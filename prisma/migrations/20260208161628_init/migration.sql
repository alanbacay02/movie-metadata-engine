-- CreateEnum
CREATE TYPE "ContentType" AS ENUM ('MOVIE', 'TV');

-- CreateEnum
CREATE TYPE "CrewJob" AS ENUM ('DIRECTOR', 'WRITER', 'PRODUCER', 'CINEMATOGRAPHER', 'EDITOR', 'COMPOSER');

-- CreateEnum
CREATE TYPE "RatingSource" AS ENUM ('TMDB');

-- CreateTable
CREATE TABLE "movies" (
    "id" SERIAL NOT NULL,
    "tmdb_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "overview" TEXT,
    "type" "ContentType" NOT NULL DEFAULT 'MOVIE',
    "release_date" TIMESTAMP(3),
    "language" TEXT,
    "runtime" INTEGER,
    "poster_url" TEXT,
    "backdrop_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "movies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "genres" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "genres_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "movie_genres" (
    "movie_id" INTEGER NOT NULL,
    "genre_id" INTEGER NOT NULL,

    CONSTRAINT "movie_genres_pkey" PRIMARY KEY ("movie_id","genre_id")
);

-- CreateTable
CREATE TABLE "people" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "tmdb_id" INTEGER NOT NULL,

    CONSTRAINT "people_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "movie_casts" (
    "movie_id" INTEGER NOT NULL,
    "person_id" INTEGER NOT NULL,
    "character" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "movie_casts_pkey" PRIMARY KEY ("movie_id","person_id")
);

-- CreateTable
CREATE TABLE "movie_crew" (
    "movie_id" INTEGER NOT NULL,
    "person_id" INTEGER NOT NULL,
    "job" TEXT NOT NULL,

    CONSTRAINT "movie_crew_pkey" PRIMARY KEY ("movie_id","person_id")
);

-- CreateTable
CREATE TABLE "rating" (
    "id" SERIAL NOT NULL,
    "movie_id" INTEGER NOT NULL,
    "source" "RatingSource" NOT NULL,
    "ratingValue" DOUBLE PRECISION DEFAULT 0,
    "voteCount" INTEGER DEFAULT 0,
    "popularity" DOUBLE PRECISION DEFAULT 0,
    "vote_average" DOUBLE PRECISION DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rating_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "movies_tmdb_id_key" ON "movies"("tmdb_id");

-- CreateIndex
CREATE UNIQUE INDEX "genres_name_key" ON "genres"("name");

-- CreateIndex
CREATE UNIQUE INDEX "people_tmdb_id_key" ON "people"("tmdb_id");

-- AddForeignKey
ALTER TABLE "movie_genres" ADD CONSTRAINT "movie_genres_movie_id_fkey" FOREIGN KEY ("movie_id") REFERENCES "movies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movie_genres" ADD CONSTRAINT "movie_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "genres"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movie_casts" ADD CONSTRAINT "movie_casts_movie_id_fkey" FOREIGN KEY ("movie_id") REFERENCES "movies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movie_casts" ADD CONSTRAINT "movie_casts_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "people"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movie_crew" ADD CONSTRAINT "movie_crew_movie_id_fkey" FOREIGN KEY ("movie_id") REFERENCES "movies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "movie_crew" ADD CONSTRAINT "movie_crew_person_id_fkey" FOREIGN KEY ("person_id") REFERENCES "people"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_movie_id_fkey" FOREIGN KEY ("movie_id") REFERENCES "movies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
