CREATE TABLE "users" (
  id serial PRIMARY KEY,
  first_name varchar(64) NOT NULL,
  last_name varchar(64) NOT NULL,
  email varchar(256) NOT NULL CHECK (email != ''),
  is_male boolean NOT NULL,
  birthday date NOT NULL CHECK (
    birthday < current_date
    AND birthday > '1900/1/1'
  ),
  height numeric(3, 2) NOT NULL CHECK (
    height > 0.20
    AND height < 2.5
  ),
  CONSTRAINT "CK_FULL_NAME" CHECK (
    first_name != ''
    AND last_name != ''
  )
);
ALTER TABLE "users"
ADD COLUMN "weight" int CHECK(
    "weight" BETWEEN 0 AND 500
  );
/*  */
CREATE TABLE "phones"(
  "id" serial PRIMARY KEY,
  "brand" varchar(64) NOT NULL,
  "model" varchar(64) NOT NULL,
  "price" decimal(10, 2) NOT NULL CHECK("price" >= 0),
  "quantity" int NOT NULL CHECK("quantity" > 0),
   UNIQUE("brand", "model")
);
/*  */
CREATE TABLE "orders"(
  "id" serial PRIMARY KEY,
  "user_id" int REFERENCES "users"("id")
);
/*  */
CREATE TABLE "phones_to_orders"(
  "phone_id" int REFERENCES "phones"("id"),
  "order_id" int REFERENCES "orders"("id"),
  "quantity" int NOT NULL CHECK("quantity" > 0),
  "is_done" boolean NOT NULL ,
  PRIMARY KEY ("phone_id", "order_id")
);


CREATE TABLE "smartphones" (
  "id" serial PRIMARY KEY,
  "manufacturer" varchar(64),
  "model" varchar(64),
  "OS" varchar(64),
  "RAM" int,
  "price" decimal(16, 2),
  UNIQUE ("manufacturer", "model"),
  CHECK ("manufacturer" != '' AND "model" !='' AND "RAM" > 0 AND "price" > 0)
)

SELECT *
FROM "users"
WHERE "is_male" = true

SELECT *
FROM "users"
WHERE "is_male" = false

SELECT *
FROM "users"
WHERE "birthday" < current_date - make_interval (years => 18)

SELECT *
FROM "users"
WHERE "birthday" < current_date - make_interval (years => 18) AND "is_male" = false

SELECT *
FROM "users"
WHERE age("birthday") BETWEEN make_interval (years => 20) AND make_interval (years => 40)

SELECT *
FROM "users"
WHERE age("birthday") > make_interval (years => 20) AND "height" > 1.8

SELECT *
FROM "users"
WHERE extract (month from "birthday") = 9

SELECT *
FROM "users"
WHERE extract (month from "birthday") = 10 AND extract (day from "birthday") = 1

SELECT 
"first_name",
"last_name",
char_length(concat("first_name",' ',"last_name")) AS "Name leght"
FROM "users"
WHERE char_length(concat("first_name",' ',"last_name")) > 15

SELECT avg(height)
FROM "users"

SELECT avg("height"), "is_male"
FROM "users"
GROUP BY "is_male"

SELECT min("height") AS "min",
max("height") AS "max",
avg("height") AS "avg",
  "is_male"
FROM "users"
GROUP BY "is_male"

SELECT count (*)
FROM "users"
WHERE "birthday" = '1970-01-01'

SELECT count (*) AS "Count", "first_name" AS "Name"
FROM "users"
GROUP BY "first_name"

SELECT count (*) 
FROM "users"
WHERE extract(years from age("birthday")) BETWEEN 20 AND 30





