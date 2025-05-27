--13.1 Создание таблицы table1
CREATE TABLE table1 (
    id1 int,
    id2 int,
    gen1 text,
    gen2 text,
    PRIMARY KEY (id1, id2, gen1)
);
--13.2 Создание таблицы table2 с использованием LIKE
CREATE TABLE table2 (LIKE table1);
---- 13.3 Проверить, какое количество внешних таблиц присутствует в бд
SELECT COUNT(*) 
FROM pg_catalog.pg_foreign_table;
--13.4  Генерация и вставка данных
-- Вставка 200,000 строк в table1
INSERT INTO table1 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 200000) gen;

-- Вставка 400,000 строк в table2
INSERT INTO table2 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 400000) gen;
--13.5 Посмотрите план соединения таблиц
explain select *
from table1
join table2 on table1.id1 = table2.id1;
--13.6
SELECT t1.*,t2.*
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select t1.* , t2.*
from table1 t1
join table2 t2 on t1.id1 = t2.id2;

--13.7
-- Считаем количество записей для каждого id1
SELECT id1, COUNT(*) 
FROM table1 
GROUP BY id1;
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT id1, COUNT(*) 
FROM table1 
GROUP BY id1;

-- Соединяем таблицы по полю id1
SELECT t1.id1, t1.gen1, t2.gen2
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1
LIMIT 10;
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT t1.id1, t1.gen1, t2.gen2
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1
LIMIT 10;

-- Находим записи из table1, которые есть в table2
SELECT id1, gen1
FROM table1
WHERE id1 IN (SELECT id1 FROM table2);
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT id1, gen1
FROM table1
WHERE id1 IN (SELECT id1 FROM table2);

