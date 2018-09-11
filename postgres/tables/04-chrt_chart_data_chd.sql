DROP TABLE IF EXISTS chrt_chart_data_chd;

CREATE TABLE chrt_chart_data_chd (
    pk_chd_id SERIAL PRIMARY KEY,
    fk_cht_chd_chart_id INTEGER REFERENCES chrt_chart_cht(pk_cht_id),
    chd_serie_name TEXT,
    chd_label_name TEXT,
    chd_value numeric
);