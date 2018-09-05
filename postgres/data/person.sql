DROP TABLE IF EXISTS person;
CREATE TABLE person (
    age int,
    gender CHAR(1),
    salary int
);
--/
DO
$CODE$
DECLARE
    v_count INT = 10000;
BEGIN
    WHILE v_count > 0 LOOP
        INSERT INTO person (age, gender, salary)
        SELECT
            floor(random() * 80) + 15,
            CASE WHEN random() > 0.5 THEN 'F' ELSE 'M' END,
            floor(random() * 150000) + 1000;
        v_count = v_count - 1;
    END LOOP;
END
$CODE$
/