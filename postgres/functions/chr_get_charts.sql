CREATE OR REPLACE FUNCTION chr_get_charts() RETURNS json
AS $CODE$
BEGIN
    RETURN (
        SELECT json_agg(
            chr_get_chart(pk_cht_id)
        )
        FROM chrt_chart_cht
    );
END
$CODE$ language plpgsql