DROP TABLE IF EXISTS chrt_lookup_lkp;

CREATE TABLE chrt_lookup_lkp (
    pk_lkp_id SERIAL PRIMARY KEY,
    fk_lty_lkp_lookup_type_id INT REFERENCES chrt_lookup_type_lty(pk_lty_id),
    lkp_name TEXT,
    lkp_description TEXT,
    lkp_code TEXT
);

INSERT INTO chrt_lookup_lkp (fk_lty_lkp_lookup_type_id, lkp_name, lkp_description, lkp_code)
SELECT pk_lty_id, 'Chart.js', 'Chart.js', 'Chart.js' FROM chrt_lookup_type_lty WHERE lty_name = 'Chart types' UNION ALL
SELECT pk_lty_id, 'Bar', 'Bar chart', 'bar' FROM chrt_lookup_type_lty WHERE lty_name = 'Chart js types' UNION ALL
SELECT pk_lty_id, 'Pie', 'Pie chart', 'pie' FROM chrt_lookup_type_lty WHERE lty_name = 'Chart js types' UNION ALL
SELECT pk_lty_id, 'Line', 'Line chart', 'line' FROM chrt_lookup_type_lty WHERE lty_name = 'Chart js types' UNION ALL
SELECT pk_lty_id, 'Radar', 'Radar chart', 'radar' FROM chrt_lookup_type_lty WHERE lty_name = 'Chart js types';