DROP TABLE IF EXISTS person;
CREATE TABLE person (
    age int,
    gender CHAR(1),
    salary int,
    city TEXT,
    activity TEXT
);
--/
DO
$CODE$
DECLARE
    v_count INT = 10000;
    v_current_random numeric;
    v_gender_percent numeric = random();
BEGIN
    CREATE LOCAL TEMP TABLE temp_cities (
        city TEXT,
        odds numeric
    ) ON COMMIT DROP ;
    INSERT INTO temp_cities
    SELECT 'London', random()
    UNION ALL SELECT 'Paris', random()
    UNION ALL SELECT 'New York', random()
    UNION ALL SELECT 'Singapour', random()
    UNION ALL SELECT 'Berlin', random()
    UNION ALL SELECT 'Beijin', random()
    UNION ALL SELECT 'Brasilila', random()
    UNION ALL SELECT 'Sidney', random()
    UNION ALL SELECT 'Madrid', random()
    UNION ALL SELECT 'Rome', random();
    
    CREATE LOCAL TEMP TABLE temp_activities (
        activity TEXT,
        odds numeric
    ) ON COMMIT DROP ;
    INSERT INTO temp_activities
    SELECT 'Pony', random()
    UNION ALL SELECT 'Rugby', random()
    UNION ALL SELECT 'Football', random()
    UNION ALL SELECT 'Tennis', random()
    UNION ALL SELECT 'Swimming', random()
    UNION ALL SELECT 'Running', random();


    WHILE v_count > 0 LOOP
        INSERT INTO person (age, gender, city, activity)
        SELECT
            floor(random() * 80) + 15,
            CASE WHEN random() > v_gender_percent THEN 'F' ELSE 'M' END,
            (
                SELECT c.city
                from temp_cities c
                where c.odds < random()
                ORDER BY c.odds desc
                LIMIT 1
            ),
            (
                SELECT a.activity
                from temp_activities a
                where a.odds < random()
                ORDER BY a.odds desc
                LIMIT 1
            );
        v_count = v_count - 1;
    END LOOP;

    UPDATE person
    SET salary = (floor(random() * 150000) + 1000) * age / 100;

    UPDATE person
    SET salary = salary * CASE WHEN gender = 'F' THEN 1.15 ELSE 1.0 END;
END
$CODE$
/
