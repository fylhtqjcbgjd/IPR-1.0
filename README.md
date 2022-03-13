# IPR-1.0

## Содержание:

### 1. [SQL](/SQL/README.md)

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

> <a href="https://office-menu.ru/uroki-sql/92-sql-join">Источник</a></br>

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
> http://2sql.ru/novosti/sql-union/ <br>
> https://function-x.ru/sql_union.html <br>
> http://www.sql-tutorial.ru/ru/book_union.html <br>

##### <a name="SQL-Index"></a> Индексы

> [Индексы](https://habr.com/ru/post/247373/ "Статья Хабр")<br>

##### <a name="Triger"></a> Триггеры

> [Триггеры](https://metanit.com/sql/sqlserver/12.1.php )<br>

##### <a name="Key"></a> Ключи

### <a name="API"></a> API

##### <a name="RESTful"></a> RESTful API
Изучить что такое RESTful API и чем оно отличается от REST
> <a href="https://habr.com/ru/post/483202/">Источник</a></br>

REST расшифровывается как REpresentational State Transfer. Это был термин, первоначально введен Роем 
Филдингом (Roy Fielding), который также был одним из создателей протокола HTTP. Отличительной особенностью сервисов 
REST является то, что они позволяют наилучшим образом использовать протокол HTTP. Теперь давайте кратко 
рассмотрим HTTP.

Важно отметить, что с REST вам нужно думать о приложении с точки зрения ресурсов:
Определите, какие ресурсы вы хотите открыть для внешнего мира
Используйте глаголы, уже определенные протоколом HTTP, для выполнения операций с этими ресурсами.

Вот как обычно реализуется служба REST:

* **Формат обмена данными**: здесь нет никаких ограничений. JSON — очень популярный формат, хотя можно использовать 
* и другие, такие как XML
* **Транспорт**: всегда HTTP. REST полностью построен на основе HTTP.
* **Определение сервиса**: не существует стандарта для этого, а REST является гибким. Это может быть недостатком 
в некоторых сценариях, поскольку потребляющему приложению может быть необходимо понимать форматы запросов 
и ответов. Однако широко используются такие языки определения веб-приложений, как WADL (Web Application 
Definition Language) и Swagger.

REST фокусируется на ресурсах и на том, насколько эффективно вы выполняете операции с ними, используя HTTP.

* REST (REpresentation State Transfer) - это архитектура, с помощью которой создаются веб-сервисы. 
* RESTful - это способ написания сервисов с использованием архитектур REST.

##### <a name="MethodHTTP"></a> методы HTTP

* GET: получить подробную информацию о ресурсе
* POST: создать новый ресурс
* PUT: обновить существующий ресурс
* DELETE: Удалить ресурс

### <a name="Архитектура"></a> Архитектура

##### <a name="MVC"></a> MVC

> [Статья: Битрикс, HMVC и немного бреда…](https://habr.com/ru/post/279017/ "Статья Хабр")<br>
> <a href="https://habr.com/ru/post/321050/">Источник</a></br>

##### <a name="Singleton"></a> Singleton

> <a href="https://refactoring.guru/ru/design-patterns/singleton">Singleton</a></br>

Singleton -  это порождающий паттерн проектирования, который гарантирует, что у класса есть только один экземпляр, 
и предоставляет к нему глобальную точку доступа.

##### <a name="DI&DI-Container"></a> DI и DI Container

### <a name="PHP"></a> PHP

##### <a name="Composer"></a> Composer

"Изучить инструмент composer. Какие задачи выполняет, какой PSR реализует.
Рассказать чем отличаются composer.json и composer.lock, и что из них нужно комитить

> <a href="https://office-menu.ru/uroki-sql/92-sql-join">Источник</a></br>

Composer — менеджер пакетов для PHP
Библиотеки перечислены в файле composer.json — ключевой файл при работе с composer.
Для установки библиотек `composer install`
После установки появляется папка vendor, куда складываются установленные пакеты и формируется файл `autoload.php`
Этот файл подключаем к проекту и всё — библиотеки подключены, можно спокойно с ними работать.

Пространство имён пакета прописано в секции autoload
```
"autoload": {
   "psr-4": {
      "App\\": "local/app/"
   }
}
```
`App\\` - наименование пространства имён
`local/app/` - директория, в которой лежат файлы с классами пакета

Нам, как потребителю пакета, достаточно прописать в наш проект<br>
`include '../vendor/autoload.php';`
и все эти классы и пространства имён будут отлично работать.
При этом нам не нужно заморачиваться и писать автозагрузчик. Composer это сделает сам при выполнении команды `install`.

###### Команды:<br>
`install` — установка пакетов, прописанных в composer.json<br>
`update` – обновление пакетов<br>
`dumpautoload`— пересборка автозагрузчика<br>
`require somepackage/somepackage:someversion` — добавление нового пакета (по умолчанию пакеты ставятся 
из оф. репозитория). При установке пакет прописывается в composer.json<br>
`update --lock` — обновление файла блокировки composer.lock<br>
`config --global cache-files-maxsize «2048MiB»` — пример изменения параметра конфигурации<br>
`--profile` — добавление этого параметра к любой команде включит показ времени выполнения и объёма использованной 
памяти<br>
`--verbose` — подробная инфомация о выполняемой операции<br>
`show --installed` — список установленных пакетов с описанием каждого<br>
`show --platform` — сведения о PHP<br>
`--dry-run` — репетиция выполнения команды. Может добавляться к командам `install` и `update`. Эмулирует выполнение 
команды без её непосредственного выполнения. Необходим для того, чтобы проверить пройдёт ли установка пакетов и 
зависимостей успешно.<br>
`remove` — удаление пакета. Точная противоположность `require`<br>

###### Синтаксис composer.json
Имя пакета состоит из двух частей разделёных косой чертой: названия поставщика (vendor name) и названия библиотеки. 
`"getjump/vk": "*",`

Если пакет оформлен в соответствии со стандартом PSR-4, но опубликован не на packagist.org, а на github,
то вместо версии пакета нужно прописать ветку и репозиторий для этого пакета

Файл `composer.lock` сохраняет текущий список установленных зависимостей и их версии. Таким образом, на момент, 
когда версии зависимостей уже будут обновлены (команда `update`), другие люди, которые будут клонировать ваш проект, 
получат те же самые версии. Это позволяет убедиться в том, что каждый, кто получает ваш проект, имеет пакетное 
окружение, идентичное тому, которое вы использовали при разработке, и помогает избежать ошибок, которые могли бы 
возникнуть из-за обновления версий.

При каждом выполнении команды `update` версии обновлённый пакетов прописываются в `composer.lock`. Этот файл 
загоняется под систему контроля версий и при установке пакетов на новом сервере поставятся именно те версии пакетов, 
которые прописаны в этом файле. При выполнении команды `install` composer будет в первую очередь опираться 
на `composer.lock`. Таким образом на разных серверах будет гарантированно установлено одинаковое пакетное окружение 
с точки зрения версий.

Также, файл `composer.lock` содержит хэш файла `composer.json`.
И если `json` файл был отредактирован, то composer выдаст предупреждение, что файл `lock` не соответствует `json` файлу.

В таком случае, нужно выполнить команду `composer update --lock`, которая обновит `composer.lock`.

Команда composer install делает следующее:<br>
— Проверяет существует ли composer.lock: <br>
——— если нет, резолвит зависимости и создаёт его<br>
———  если composer.lock существует, устанавливает версии, указанные в нём<br>

Команда composer update:<br>
— Проверяет composer.json <br>
— Определяет последние версии на основе указанных в этом файле <br>
— Устанавливает последние версии <br>
— Обновляет composer.lock в соответствии с установленными <br>

##### <a name="ООП"></a> ООП

> <a href="https://www.scorp13.com/workflow/raznica-mezhdu-abstraktnym-klassom-i-interfeysom-v-php.html">Абстрактный класс и интерфейс</a></br>


### <a name="Статический-анализ"></a> Статический анализ

##### <a name="StatAnalize"></a> статические анализаторы кода

> <a href="https://habr.com/ru/company/skyeng/blog/529350/">Источник</a></br>
> <a href="https://habr.com/ru/company/badoo/blog/426605/">Источник</a></br>

Статические анализаторы появились с выходом PHP 7. И были созданы проверки соответсвия типизации в коде.
После они обрастали проверками на безопасность на чистотут кода.</br>
PHPStan, Psalm, Phan</br>
Статические анализаторы кода просто читают код и пытаются найти в нём ошибки. Они могут выполнять как очень простые и
очевидные проверки (например, на существование классов, методов и функций, так и более хитрые (например, искать
несоответствие типов, race conditions или уязвимости в коде). Ключевым является то, что анализаторы не выполняют код —
они анализируют текст программы и проверяют её на типичные (и не очень) ошибки.

##### <a name="PHPMD"></a> PHPMD

PHP Mess Detector (обнаружитель беспорядков), будучи установленным, обрабатывает ваш код утилитой PHP_Depend и 
использует полученные метрики для составления собственных отчётов.

PHPMD пытается выявить ошибки, которые не находит компилятор, не оптимальные алгоритмы, переусложнённый код, 
не используемые выражения и другие подобные проблемы.

### <a name="Инфраструктура"></a> Инфраструктура

##### <a name="docker-compose"></a> docker-compose

##### <a name="docker"></a> docker

##### <a name="Образ&Контейнер"></a> Образ и Контейнер

##### <a name="Проброс-портов"></a> Проброс-портов

##### <a name="Оркестратор"></a> Оркестратор

##### <a name="Слои"></a> Слои

