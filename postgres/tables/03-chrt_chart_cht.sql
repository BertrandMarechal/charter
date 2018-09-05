DROP TABLE IF EXISTS chrt_chart_cht;

CREATE TABLE chrt_chart_cht (
    pk_cht_id SERIAL PRIMARY KEY,
    cht_name TEXT,
    cht_labels_query TEXT,
    fk_lkp_cht_chart_type INT REFERENCES chrt_lookup_lkp(pk_lkp_id),
    fk_lkp_cht_chart_sub_type INT REFERENCES chrt_lookup_lkp(pk_lkp_id)
);

INSERT INTO chrt_chart_cht (cht_name, cht_labels_query, fk_lkp_cht_chart_type, fk_lkp_cht_chart_sub_type)
SELECT 'Person per gender', 'SELECT ''{"Female","Male"}''', lkp_type.pk_lkp_id, lkp_type.pk_lkp_id
FROM chrt_lookup_lkp lkp_type
INNER JOIN chrt_lookup_type_lty lty_type
    ON lty_type.pk_lty_id = lkp_type.fk_lty_lkp_lookup_type_id
    AND lty_type.lty_name = 'Chart types'
    AND lkp_type.lkp_code = 'Chart.js'
INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.lkp_code = 'bar'
INNER JOIN chrt_lookup_type_lty lty_sub_type
    ON lty_sub_type.pk_lty_id = lkp_sub_type.fk_lty_lkp_lookup_type_id
    AND lty_sub_type.lty_name = 'Chart js types';
    
    