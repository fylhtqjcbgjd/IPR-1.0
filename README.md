# IPR-1.0

## Содержание:

### 1. [SQL](#SQL)

+ [Отличия между MyISAM и InnoDB](#MyISAM&InnoDB)
+ [Объединение таблиц](#JOIN&UNION "Разбор какие бывают JOINы и UNIONы, в каком случае что использовать")
+ [Индексы](#SQL-Index "Разбор какую функцию несут, допустимое количество и какие ограничение накладывает их использование")
+ [Триггеры](#Triger "виды, область применения, плюсы и минусы")
+ [Ключи](#Key "виды, область применения, плюсы и минусы")

### 2. [API](#API)

+ [RESTful API](#RESTful "Изучить что такое RESTful API и чем оно отличается от REST")
+ [методы HTTP](#MethodHTTP "Какие бывают методы HTTP запросов и чем отличаются.")

### 3. [Архитектура](#Архитектура)

+ [MVC](#MVC "Разобрать отличие классического MVP от реализации в Битрикс")
+ [Singleton](#Singleton "Понимать где уместно использовать паттерн Singleton")
+ [DI и DI Container](#DI&DI-Container "Изучить шаблоны DI и DI Container")

### 4. [PHP](#PHP)

+ [Composer](#Composer "Изучить инструмент composer. Какие задачи выполняет, какой PSR реализует. Рассказать чем отличаются composer.json и composer.lock, и что из них нужно комитить")
+ [ООП](#ООП "Уверенно ориентироваться в ООП (классы, интерфейсы, трейты, модификаторы доступа, наследование)")

### 5. [Статический анализ](#Статический-анализ)

+ [статические анализаторы кода](#StatAnalize "Сформировать понимание что такое статические анализаторы кода и зачем они нужны")
+ [PHPMD](#PHPMD "В текущий проект или пет проект внедрить PHPMD")

### 6. [Инфраструктура](#Инфраструктура)

+ [docker-compose](#docker-compose "Макет для отработки SQL собрать с использованием docker-compose")
+ [docker](#docker "Разобраться как писать свои докер файлы")
+ [Образ и Контейнер](#Образ&Контейнер "Чем отличается Образ от Контейнера и как они взаимодействуют")
+ [Проброс портов](#Проброс-портов "Научиться пробрасывать порты и директории в контейнер, а также между ними")
+ [Оркестратор](#Оркестратор "Знать что такое Оркестратор и зачем он нужен. Какие бывают Оркестраторы")
+ [Слои](#Слои "Иметь представление что такое слои и зачем они нужны")

### <a name="SQL"></a> SQL

##### <a name="MyISAM&InnoDB"></a> Отличия между MyISAM и InnoDB

##### <a name="JOIN&UNION"></a> Объединение таблиц

<a href="https://office-menu.ru/uroki-sql/92-sql-join">Источник</a></br>

```sql
CREATE TABLE Authors(
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    AuthorName VARCHAR(30)
);

INSERT INTO Authors (AuthorName) VALUES ('Bruce Eckel');
INSERT INTO Authors (AuthorName) VALUES ('Robert Lafore');
INSERT INTO Authors (AuthorName) VALUES ('Andrew Tanenbaum');

CREATE TABLE Books(
    BookID INT,
    BookName VARCHAR(30)
);

INSERT INTO Books (BookName, BookID) VALUES ('Modern Operating System', 3);
INSERT INTO Books (BookName, BookID) VALUES ('Thinking in Java', 1);
INSERT INTO Books (BookName, BookID) VALUES ('Computer Architecture', 3);
INSERT INTO Books (BookName, BookID) VALUES ('Programming in Scala', 4);

SELECT * FROM Books;
SELECT * FROM Authors;
```

https://www.jdoodle.com/execute-sql-online/

**JOIN** - оператор для сондинения таблиц, посредством сравнения их между собой с возможностью вывода столбцов 
из всех таблиц, участвующих в соединении.</br>
**_Таблицы для примеров:_**
Authors — содержит в себе информацию об авторах книг:

|AuthorID|AuthorName|
| ------ | ------- |
|1|Bruce Eckel|
|2|Robert Lafore|
|3|Andrew Tanenbaum|

Books — содержит в себе информацию о названии книг:

|BookID|BookName|
| ------ | ------- |
|3|Modern Operating System|
|1|Thinking in Java|
|3|Computer Architecture|
|4|Programming in Scala|

**Виды JOIN:**</br>
**INNER JOIN** - формирует таблицу из записей двух или нескольких таблиц. Каждая строка из первой (левой) таблицы, 
сопоставляется с каждой строкой из второй (правой) таблицы, после чего происходит проверка условия. Если условие истинно,
то строки попадают в результирующую таблицу.</br>
**_Примеры:_**

```sql
SELECT
    column_names [,... n]
FROM
    Table_1 INNER JOIN Table_2
ON condition

--Пример объединение таблиц книг и их авторов по id
SELECT * FROM Authors INNER JOIN Books
ON Authors.AuthorID = Books.BookID
```

|Authors.AuthorID|Authors.AuthorName|Books.BookID|Books.BookName|
| ------ | ------- | ------- | ------- |
|3|Andrew Tanenbaum|3|Modern Operating System|
|1|Bruce Eckel|1|Thinking in Java|
|3|Andrew Tanenbaum|3|Computer Architecture|

**LEFT JOIN** - осуществляет формирование таблицы из записей двух или нескольких таблиц. В операторе ``SQL LEFT JOIN``, 
как и в операторе ``SQL RIGHT JOIN``, важен порядок следования таблиц, так как от этого будет зависеть полученный результат. 
Алгоритм работы оператора следующий:
1. Сначала происходит формирование таблицы внутренним соединением (оператор ``SQL INNER JOIN``) левой и правой таблиц
2. Затем, в результат добавляются записи левой таблицы не вошедшие в результат формирования таблицы внутренним соединением.
Для них, соответствующие записи из правой таблицы заполняются значениями ``NULL``.</br>
**_Примеры:_**
```sql
SELECT
    column_names [,... n]
FROM
    Table_1 LEFT JOIN Table_2
ON condition

--Пример объединение таблиц книг и их авторов по id
SELECT * FROM Authors LEFT JOIN Books
ON Authors.AuthorID = Books.BookID
```
|Authors.AuthorID|Authors.AuthorName|Books.BookID|Books.BookName|
| ------ | ------- | ------- | ------- |
|1|Bruce Eckel|1|Thinking in Java|
|2|Robert Lafore|NULL|NULL|
|3|Andrew Tanenbaum|3|Modern Operating System|
|3|Andrew Tanenbaum|3|Computer Architecture|

**RIGHT JOIN** - осуществляет формирование таблицы из записей двух или нескольких таблиц.
В операторе ``SQL RIGHT JOIN``, как и в операторе ``SQL LEFT JOIN``, важен порядок следования таблиц, так как от этого 
будет зависеть полученный результат. Алгоритм работы оператора следующий:

1. Сначала происходит формирование таблицы внутренним соединением (оператор ``SQL INNER JOIN``) левой и правой таблиц
2. Затем, в результат добавляются записи правой таблицы не вошедшие в результат формирования таблицы внутренним соединением. 
Для них, соответствующие записи из левой таблицы заполняются значениями ``NULL``.</br>
   **_Примеры:_**
```sql
SELECT
    column_names [,... n]
FROM
    Table_1 RIGHT JOIN Table_2 ON condition

--Пример объединение таблиц книг и их авторов по id
SELECT * FROM Authors
RIGHT JOIN Books ON Authors.AuthorID = Books.BookID
```
|Authors.AuthorID|Authors.AuthorName|Books.BookID|Books.BookName|
| ------ | ------- | ------- | ------- |
|3|Andrew Tanenbaum|3|Modern Operating System|
|1|Bruce Eckel|1|Thinking in Java|
|3|Andrew Tanenbaum|3|Computer Architecture|
|NULL|NULL|4|Programming in Scala|

**FULL JOIN** - осуществляет формирование таблицы из записей двух или нескольких таблиц. В операторе `SQL FULL JOIN`` 
не важен порядок следования таблиц, он никак не влияет на окончательный результат, так как оператор является симметричным.

Оператор ``SQL FULL JOIN`` можно воспринимать как сочетание операторов ``SQL INNER JOIN + SQL LEFT JOIN + SQL RIGHT JOIN``. 
Алгоритм его работы следующий:

1. Сначала формируется таблица на основе внутреннего соединения (оператор ``SQL INNER JOIN``).
2. Затем, в таблицу добавляются значения не вошедшие в результат формирования из правой таблицы 
(оператор ``SQL LEFT JOIN``). Для них, соответствующие записи из правой таблицы заполняются значениями ``NULL``.
3. Наконец, в таблицу добавляются значения не вошедшие в результат формирования из левой таблицы 
(оператор ``SQL RIGHT JOIN``). Для них, соответствующие записи из левой таблицы заполняются значениями ``NULL``.</br>
**_Примеры:_**
```sql
SELECT
    column_names [,... n]
FROM
    Table_1 FULL JOIN Table_2
ON condition

--Пример объединение таблиц книг и их авторов по id
SELECT *
FROM Authors FULL JOIN Books
ON Authors.AuthorID = Books.BookID
```
|Authors.AuthorID|Authors.AuthorName|Books.BookID|Books.BookName|
| ------ | ------- | ------- | ------- |
|1|Bruce Eckel|1|Thinking in Java|
|2|Robert Lafore|NULL|NULL|
|3|Andrew Tanenbaum|3|Modern Operating System|
|3|Andrew Tanenbaum|3|Computer Architecture|
|NULL|NULL|4|Programming in Scala|

**CROSS JOIN** - формирует таблицу перекрестным соединением (декартовым произведением) двух таблиц.
При использовании оператора SQL CROSS JOIN каждая строка левой таблицы сцепляется с каждой строкой правой таблицы. 
В результате получается таблица со всеми возможными сочетаниями строк обеих таблиц.</br>
**_Примеры:_**
```sql
SELECT
    column_names [,... n]
FROM
    Table_1 CROSS JOIN Table_2

--Пример объединение таблиц книг и их авторов по id
SELECT *
FROM Authors CROSS JOIN Books
```

|Authors.AuthorID|Authors.AuthorName|Books.BookID|Books.BookName|
|1|Bruce Eckel|3|Modern Operating System|
|1|Bruce Eckel|1|Thinking in Java<|
|1|Bruce Eckel|3|Computer Architecture|
|1|Bruce Eckel|4|Programming in Scala|
|2|Robert Lafore|3|Modern Operating System|
|2|Robert Lafore|1|Thinking in Java|
|2|Robert Lafore|3|Computer Architecture|
|2|Robert Lafore|4|Programming in Scala|
|3|Andrew Tanenbaum|3|Modern Operating System|
|3|Andrew Tanenbaum|1|Thinking in Java|
|3|Andrew Tanenbaum|3|Computer Architecture|
|3|Andrew Tanenbaum|4|Programming in Scala|

**SELF JOIN** - используется для объединения таблицы с ней самой таким образом, будто это две разные таблицы, 
временно переименовывая одну из них.</br>

**_Примеры:_**
```sql
???
--Пример объединение ????
???
```
**UNION** - оператор для объединения двух и более запросов оператора ``SQL SELECT``.

**_Примеры:_**
```sql
SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2
--Пример объединение ????
???
```
http://2sql.ru/novosti/sql-union/
https://function-x.ru/sql_union.html
http://www.sql-tutorial.ru/ru/book_union.html

##### <a name="SQL-Index"></a> Индексы

##### <a name="Triger"></a> Триггеры

##### <a name="Key"></a> Ключи

### <a name="API"></a> API

##### <a name="RESTful"></a> RESTful API

##### <a name="MethodHTTP"></a> методы HTTP

### <a name="Архитектура"></a> Архитектура

##### <a name="MVC"></a> MVC

> [Статья: Битрикс, HMVC и немного бреда…](https://habr.com/ru/post/279017/ "Статья Хабр")

##### <a name="Singleton"></a> Singleton

##### <a name="DI&DI-Container"></a> DI и DI Container

### <a name="PHP"></a> PHP

##### <a name="Composer"></a> Composer

##### <a name="ООП"></a> ООП

### <a name="Статический-анализ"></a> Статический анализ

##### <a name="StatAnalize"></a> статические анализаторы кода

##### <a name="PHPMD"></a> PHPMD

### <a name="Инфраструктура"></a> Инфраструктура

##### <a name="docker-compose"></a> docker-compose

##### <a name="docker"></a> docker

##### <a name="Образ&Контейнер"></a> Образ и Контейнер

##### <a name="Проброс-портов"></a> Проброс-портов

##### <a name="Оркестратор"></a> Оркестратор

##### <a name="Слои"></a> Слои

