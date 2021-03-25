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

SELECT sum (quantity) AS "Selled phones"
FROM "phones_to_orders"

SELECT sum (quantity) AS "Phones in stock"
FROM "phones"

SELECT avg (price) AS "Midle price"
FROM "phones"

SELECT avg (price) AS "Midle price", "brand"
FROM "phones"
GROUP BY "brand"

SELECT sum (price*quantity) AS "Sum of prices"
FROM "phones"
WHERE "price" BETWEEN 10000 AND 20000

SELECT count (model) AS "Model count", "brand"
FROM "phones"
GROUP BY "brand"

SELECT count (model) AS "Model count", "brand"
FROM "phones"
GROUP BY "brand"

SELECT count (*) AS "User orders count", "userId"
FROM "orders"
GROUP BY "userId"

SELECT avg (price) AS "Midle price", "brand"
FROM "phones"
WHERE "brand" = 'IPhone'
GROUP BY "brand"

SELECT "firstName" AS "First Name",
"lastName" AS "Last Name",
extract(years from age("birthday")) AS "Age"
FROM "users"
ORDER BY extract(years from age("birthday")), "firstName"

SELECT *
FROM "users"
WHERE "firstName" ILIKE 'J%' AND "lastName" ILIKE 'D%'

SELECT max(char_length(concat("firstName",' ',"lastName")))
FROM "users"

SELECT count (*) AS "Count", char_length(concat("firstName",' ',"lastName")) AS "Lenght"
FROM "users"
GROUP BY "Lenght"
HAVING char_length(concat("firstName",' ',"lastName")) > 18

SELECT * FROM "users"
WHERE "email" ILIKE 'm%'

SELECT sum(p.price*pto.quantity) "Price", o.id "Order ID" 
FROM "orders" o
JOIN "phones_to_orders" pto ON o.id = pto."orderId"
JOIN "phones" p ON pto."phoneId" = p.id
GROUP BY o.id
ORDER BY o.id

-- _____________________________________

SELECT o.id "Order ID", p.brand "Brand", p.model "Model"
FROM "phones" p
JOIN "phones_to_orders" pto ON pto."phoneId" = p.id
JOIN "orders" o ON pto."orderId" = o.id

SELECT count(o.id) "Order of amount", u.email "User Email"
FROM "users" u
JOIN "orders" o ON o."userId" = u.id
GROUP BY u.email

SELECT o.id "Order ID", sum(pto.quantity) "Good's amount"
FROM "orders" o
JOIN "phones_to_orders" pto ON pto."orderId" = o.id
GROUP BY o.id
ORDER BY o.id

SELECT *
FROM (SELECT sum(pto.quantity) "Sells amount", p.brand, p.model
FROM "phones" p
JOIN "phones_to_orders" pto ON pto."phoneId" = p.id
JOIN "orders" o ON pto."orderId" = o.id
GROUP BY p.id) st
ORDER BY st."Sells amount" DESC LIMIT 1

SELECT count(st.model) amount, st.email
FROM (SELECT u.id, u."firstName", u."lastName", u."email", p.brand, p.model
FROM "users" u
JOIN "orders" o ON u.id = o."userId"
JOIN "phones_to_orders" pto ON pto."orderId" = o.id
JOIN "phones" p ON pto."phoneId" = p.id
GROUP BY p.brand, p.model, u.id, u."firstName", u."lastName", u."email"
ORDER BY u.id) st
GROUP BY st."email"
ORDER BY amount DESC


WITH "orders_with_costs" AS (
  SELECT pto."orderId" "Order ID", sum(p.price*pto.quantity) "Order cost" 
  FROM phones_to_orders pto
  JOIN phones p ON pto."phoneId" = p.id
  GROUP BY pto."orderId")
SELECT owc."Order ID", owc."Order cost"
FROM "orders_with_costs" owc
WHERE owc."Order cost" > (
  SELECT avg(owc."Order cost")
  FROM "orders_with_costs" owc
)
ORDER BY owc."Order ID"


WITH "user_with_amount" AS (
  SELECT u.email "Email", count(o.id) "Orders amount"
  FROM "users" u
  JOIN "orders" o ON u.id = o."userId"
  GROUP BY u.email
)
SELECT uwa."Email", uwa."Orders amount"
FROM "user_with_amount" uwa
WHERE uwa."Orders amount" > (
  SELECT avg(uwa."Orders amount")
  FROM "user_with_amount" uwa
)


SELECT concat(p.brand, ' ', p.model) "Phone", pto."orderId"
FROM phones p
JOIN phones_to_orders pto ON pto."phoneId" = p.id
GROUP BY concat(p.brand, ' ', p.model), pto."orderId"
ORDER BY concat(p.brand, ' ', p.model)


WITH "user_with_amount" AS (
  SELECT u.email "Email", count(o.id) "Orders amount"
  FROM "users" u
  JOIN "orders" o ON u.id = o."userId"
  GROUP BY u.email
)
SELECT uwa."Email", uwa."Orders amount"
FROM "user_with_amount" uwa
WHERE uwa."Orders amount" = (
  SELECT min(uwa."Orders amount")
  FROM "user_with_amount" uwa
)










