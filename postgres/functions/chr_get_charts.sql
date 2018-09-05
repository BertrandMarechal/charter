CREATE OR REPLACE FUNCTION chr_get_charts() RETURNS json
AS $CODE$
BEGIN
    RETURN (
        SELECT json_agg(
            a.chart
        )
        FROM (
            SELECT chr_get_chart(1) chart UNION ALL
            SELECT chr_get_chart(2) chart UNION ALL
            SELECT chr_get_chart(3) chart UNION ALL
            SELECT chr_get_chart(4) chart UNION ALL
            SELECT chr_get_chart(5) chart UNION ALL
            SELECT chr_get_chart(6) chart UNION ALL
            SELECT chr_get_chart(7) chart UNION ALL
            SELECT chr_get_chart(8) chart UNION ALL
            SELECT chr_get_chart(9) chart
        ) a
    );
END
$CODE$ language plpgsql