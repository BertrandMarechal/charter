DROP TABLE IF EXISTS chrt_chart_data_chd;
DROP TABLE IF EXISTS chrt_chart_cht;

CREATE TABLE chrt_chart_cht (
    pk_cht_id SERIAL PRIMARY KEY,
    cht_name TEXT,
    cht_labels_column_name TEXT,
    cht_series_column_name TEXT,
    cht_values_column_name TEXT,
    cht_query TEXT,
    fk_lkp_cht_chart_type INT REFERENCES chrt_lookup_lkp(pk_lkp_id),
    fk_lkp_cht_chart_sub_type INT REFERENCES chrt_lookup_lkp(pk_lkp_id)
);

INSERT INTO chrt_chart_cht (cht_name, cht_labels_column_name, cht_values_column_name,cht_series_column_name,  cht_query, fk_lkp_cht_chart_type, fk_lkp_cht_chart_sub_type)
SELECT 'Person per gender', 'gender','# per gender', null,'SELECT gender, count(*) "# per gender" FROM person GROUP BY gender ORDER BY gender', lkp_type.pk_lkp_id, lkp_sub_type.pk_lkp_id
FROM chrt_lookup_lkp lkp_type
INNER JOIN chrt_lookup_type_lty lty_type
    ON lty_type.pk_lty_id = lkp_type.fk_lty_lkp_lookup_type_id
    AND lty_type.lty_name = 'Chart types'
    AND lkp_type.lkp_code = 'Chart.js'
INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.lkp_code = 'pie'
INNER JOIN chrt_lookup_type_lty lty_sub_type
    ON lty_sub_type.pk_lty_id = lkp_sub_type.fk_lty_lkp_lookup_type_id
    AND lty_sub_type.lty_name = 'Chart js types'
UNION ALL
SELECT 'Person per city', 'city','# per city', null,'SELECT city, count(*) "# per city" FROM person GROUP BY city ORDER BY city', lkp_type.pk_lkp_id, lkp_sub_type.pk_lkp_id
FROM chrt_lookup_lkp lkp_type
INNER JOIN chrt_lookup_type_lty lty_type
    ON lty_type.pk_lty_id = lkp_type.fk_lty_lkp_lookup_type_id
    AND lty_type.lty_name = 'Chart types'
    AND lkp_type.lkp_code = 'Chart.js'
INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.lkp_code = 'bar'
INNER JOIN chrt_lookup_type_lty lty_sub_type
    ON lty_sub_type.pk_lty_id = lkp_sub_type.fk_lty_lkp_lookup_type_id
    AND lty_sub_type.lty_name = 'Chart js types'
UNION ALL
SELECT 'Salary per age', 'age','salary', 'gender','
    select age abs, gender "serie", round(avg(salary)) ord
    from person group by age, gender order by age, gender', lkp_type.pk_lkp_id, lkp_sub_type.pk_lkp_id
FROM chrt_lookup_lkp lkp_type
INNER JOIN chrt_lookup_type_lty lty_type
    ON lty_type.pk_lty_id = lkp_type.fk_lty_lkp_lookup_type_id
    AND lty_type.lty_name = 'Chart types'
    AND lkp_type.lkp_code = 'Chart.js'
INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.lkp_code = 'line'
INNER JOIN chrt_lookup_type_lty lty_sub_type
    ON lty_sub_type.pk_lty_id = lkp_sub_type.fk_lty_lkp_lookup_type_id
    AND lty_sub_type.lty_name = 'Chart js types'
UNION ALL
SELECT 'Activity per genre', 'activity','count', 'gender','
    select activity abs, gender "serie", count(*) ord
    from person group by activity, gender order by activity, gender', lkp_type.pk_lkp_id, lkp_sub_type.pk_lkp_id
FROM chrt_lookup_lkp lkp_type
INNER JOIN chrt_lookup_type_lty lty_type
    ON lty_type.pk_lty_id = lkp_type.fk_lty_lkp_lookup_type_id
    AND lty_type.lty_name = 'Chart types'
    AND lkp_type.lkp_code = 'Chart.js'
INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.lkp_code = 'radar'
INNER JOIN chrt_lookup_type_lty lty_sub_type
    ON lty_sub_type.pk_lty_id = lkp_sub_type.fk_lty_lkp_lookup_type_id
    AND lty_sub_type.lty_name = 'Chart js types'
UNION ALL
SELECT 'Person per city', 'city','# per city', null,'
select city abs, ''Count'' "serie", count(*) ord
    from person group by city order by city', lkp_type.pk_lkp_id, lkp_sub_type.pk_lkp_id
FROM chrt_lookup_lkp lkp_type
INNER JOIN chrt_lookup_type_lty lty_type
    ON lty_type.pk_lty_id = lkp_type.fk_lty_lkp_lookup_type_id
    AND lty_type.lty_name = 'Chart types'
    AND lkp_type.lkp_code = 'Chart.js'
INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.lkp_code = 'polarArea'
INNER JOIN chrt_lookup_type_lty lty_sub_type
    ON lty_sub_type.pk_lty_id = lkp_sub_type.fk_lty_lkp_lookup_type_id
    AND lty_sub_type.lty_name = 'Chart js types';