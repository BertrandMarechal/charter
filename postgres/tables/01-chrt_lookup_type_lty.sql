DROP TABLE IF EXISTS chrt_lookup_type_lty;

CREATE TABLE chrt_lookup_type_lty (
    pk_lty_id SERIAL PRIMARY KEY,
    lty_name TEXT
);

INSERT INTO chrt_lookup_type_lty (lty_name)
VALUES ('Chart types'),
 ('Chart js types');