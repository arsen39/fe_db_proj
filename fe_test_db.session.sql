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

/* 
 */
CREATE TABLE "phones"(
  "id" serial PRIMARY KEY,
  "brand" varchar(64) NOT NULL,
  "model" varchar(64) NOT NULL,
  "price" decimal(10, 2) NOT NULL CHECK("price" >= 0),
  "quantity" int NOT NULL CHECK("quantit" > 0) UNIQUE("brand", "model")
);
/*  */
CREATE TABLE "orders"(
  "id" serial PRIMARY KEY,
  "user_id" int REFERENCES "users"("id")
);
/*  */
CREATE TABLE "phones_to_orders"(
  phone_id int REFERENCES "phones"("id"),
  order_id int REFERENCES "orders"("id"),
  quantity int NOT NULL CHECK("quantity" > 0),
  PRIMARY KEY (phone_id, order_id)
);


--===========
/*  */
UPDATE "users"
SET "weight" = 70
WHERE "id" = 3333;
/*  */
SELECT *
FROM "users"
WHERE "weight" = 400;
/* 
 Агрегатные функции
 
 max
 min
 sum - аккумулятор
 count - считает строки
 avg - среднее значение
 
 */
SELECT avg("weight"),
  "is_male"
FROM "users"
WHERE birthday > '1990/1/1'
GROUP BY "is_male";
/* 
 средний рост пользователей
 средний рост мужчин и женщин
 минимальный рост мужчины и женщины
 минимальный, максимальный и средний рост мужчины и женщины
 Кол-во  людей родившихся 1 января 1970 года
 Кол-во людей с определённым именем
 Кол-во людей в возрасте от 20 до 30 лет
 */
SELECT count(id)
FROM "users"
WHERE extract(
    'year'
    from age("birthday")
  ) BETWEEN 20 AND 30;