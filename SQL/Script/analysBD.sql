--Размерность и объем таблц в bd
SELECT TABLE_NAME, table_rows, data_length, index_length,
       round(((data_length + index_length) / 1024 / 1024),2) "Size in MB"
FROM information_schema.TABLES  WHERE table_schema = "sogaz"
ORDER BY (data_length + index_length) DESC;

--Удалить N элементов из таблицы
DELETE
FROM ww_metrics_users
    ORDER BY id DESC
LIMIT 5169654;

--Переиндексация после удаления
SELECT COUNT(*) FROM ww_metrics_users;
