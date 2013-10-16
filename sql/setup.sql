DROP DATABASE IF EXISTS unittest;

CREATE DATABASE IF NOT EXISTS unittest;

GRANT ALL ON unittest.* TO 'unittest'@'localhost' IDENTIFIED BY 'unittest';

USE unittest;

CREATE TABLE test(
       intValue INT,
       doubleValue DOUBLE,
       varcharValue VARCHAR(255),
       dateValue DATE,
       dateTimeValue DATETIME
);

INSERT INTO test(intValue, doubleValue, varcharValue, dateValue, dateTimeValue) VALUES(1,3.1415,'this is a string', NOW(), NOW());
