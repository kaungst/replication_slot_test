CREATE DATABASE dummy_app_dev;
\c dummy_app_dev
CREATE TABLE test_table1 (id bigint PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, col1 varchar);
INSERT INTO test_table1 (col1) VALUES ('first record');
