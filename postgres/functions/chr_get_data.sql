CREATE OR REPLACE FUNCTION chr_get_data(i_chart_id INTEGER) RETURNS json
AS $CODE$
DECLARE
        v_query TEXT = '
        SELECT gender, count(*) "# per gender"
        FROM person
        GROUP BY gender
        ORDER BY gender';
BEGIN
        EXECUTE 'CREATE LOCAL TEMP TABLE temp_chart_data
        ON COMMIT DROP AS ' || v_query;
        
        RETURN json_build_object(
                'data',(select json_agg(a.*) from temp_chart_data a),
                'columns', (
                        SELECT array_agg(attname)
                        FROM   pg_attribute
                        WHERE  attrelid = 'temp_chart_data'::regclass
                        AND    attnum > 0
                        AND    NOT attisdropped
                )
        );
END;
$CODE$ language plpgsql