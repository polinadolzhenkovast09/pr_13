# Практическая работа №13
# Цель
Научиться анализировать планы выполнения, сравнить разные типы запросов
# 13.1 Создайте таблицу tablel со следующими параметрами: Поля: idl int, id2 int, geni text, gen2 text. Сделайте поля id1, id2, gen1 первичным ключом.
````
CREATE TABLE table1 (
    id1 int,
    id2 int,
    gen1 text,
    gen2 text,
    PRIMARY KEY (id1, id2, gen1)
);
````
![image](https://github.com/user-attachments/assets/b9f2f8af-6f0e-4eba-8dcd-e174b6bc4b1a)

# 13.2  Создайте таблицу table2 со следующими параметрами: возьмите набор полей table1 с помощью директивы LIKE.
````
CREATE TABLE table2 (LIKE table1);
````

![image](https://github.com/user-attachments/assets/3c4855e3-99aa-4f7e-814e-424166610d1a)


# 13.3 Проверить, сколько внешних таблиц присутствует в БД
```
SELECT COUNT(*) 
FROM pg_catalog.pg_foreign_table;
````
![image](https://github.com/user-attachments/assets/098a4244-9629-4b5b-9dbb-61d7a9501158)

# 13.4  Сгенерируйте данные и вставьте их в обе таблицы (200 тысяч и 400 тысяч значений соответственно)
````
-- Вставка 200,000 строк в table1
INSERT INTO table1 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 200000) gen;

-- Вставка 400,000 строк в table2
INSERT INTO table2 
SELECT gen, gen, gen::text || 'text1', gen::text || 'text2' 
FROM generate_series(1, 400000) gen;
````
# 13.5  Посмотрите план соединения таблиц
````
explain select *
from table1
join table2 on table1.id1 = table2.id1;
````
![image](https://github.com/user-attachments/assets/c45f1cb1-a667-4e00-a9f3-824934672767)

# 13.6 Используя таблицы table1 и table2, реализуйте план запроса: План запроса встроенного инструмента pgAdmin
````
SELECT t1.*,t2.*
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select t1.* , t2.*
from table1 t1
join table2 t2 on t1.id1 = t2.id2;
````
![image](https://github.com/user-attachments/assets/5a0c2d13-5658-4eaf-8735-3d29e0b80650)

# 13.7 Реализовать запросы с использованием объединений, группировки, вложенного подзапроса. Экспортировать план в файл
````
SELECT t1.id1, t1.gen1, t2.gen2
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1
LIMIT 10;
````
![image](https://github.com/user-attachments/assets/e24c2972-b75a-471f-b951-49b7cdf560d1)

````
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT t1.id1, t1.gen1, t2.gen2
FROM table1 t1
JOIN table2 t2 ON t1.id1 = t2.id1
LIMIT 10;
````
![image](https://github.com/user-attachments/assets/f2b1108e-9c62-4ebd-9980-e4c9eee662f3)
![image](https://github.com/user-attachments/assets/d00c6e46-88e9-4dbc-90f8-284bbc7c7f74)

````
SELECT id1, gen1
FROM table1
WHERE id1 IN (SELECT id1 FROM table2);
````
![image](https://github.com/user-attachments/assets/3aaa719e-075b-42ef-bb1f-49f168a2b58d)

````
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT id1, gen1
FROM table1
WHERE id1 IN (SELECT id1 FROM table2);
````
![image](https://github.com/user-attachments/assets/32b65a9b-d342-4fce-88d0-cc4d62ebe9da)
![image](https://github.com/user-attachments/assets/16c6f168-2b80-430b-b47c-4d288d85fef7)

````
SELECT id1, COUNT(*) 
FROM table1 
GROUP BY id1;
````
![image](https://github.com/user-attachments/assets/d8c97b16-cd32-4c0c-93e1-b2903dd2ebf2)

````
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT id1, COUNT(*) 
FROM table1 
GROUP BY id1;
````
![image](https://github.com/user-attachments/assets/b6dd9d4d-91f9-4594-8e4a-83a6fad3d867)
![image](https://github.com/user-attachments/assets/a6a0eb9d-11b5-42be-9a89-2978686a0d6b)

# Сравните полученные результаты в пункте 13.6 локально с результатом на сайте https://tatiyants.com/pev/#f/plans/new 
![image](https://github.com/user-attachments/assets/8f86a4a7-8569-4ac9-af6d-bba881611104)
![image](https://github.com/user-attachments/assets/7941e199-8adc-4325-a2b8-036b85bbeaf8)

# Вывод
Научились анализировать планы выполнения, сравнили разные типы запросов










