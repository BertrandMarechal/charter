CREATE OR REPLACE FUNCTION chr_get_chart(i_chart_id INT) RETURNS json
AS $CODE$
BEGIN
    RETURN (
        SELECT
            CASE
                WHEN lkp_type.lkp_code = 'Chart.js' THEN
                    CASE
                        WHEN lkp_sub_type.lkp_code = 'bar' THEN
                            chr_get_chart_js_bar(pk_cht_id)
                        WHEN lkp_sub_type.lkp_code = 'pie' THEN
                            chr_get_chart_js_pie(pk_cht_id)
                        WHEN lkp_sub_type.lkp_code = 'line' THEN
                            chr_get_chart_js_line(pk_cht_id)
                        WHEN lkp_sub_type.lkp_code = 'radar' THEN
                            chr_get_chart_js_radar(pk_cht_id)
                        WHEN lkp_sub_type.lkp_code = 'polarArea' THEN
                            chr_get_chart_js_polar_area(pk_cht_id)
                        ELSE NULL
                    END
                ELSE NULL
            END
        FROM chrt_chart_cht
        INNER JOIN chrt_lookup_lkp lkp_type ON lkp_type.pk_lkp_id = fk_lkp_cht_chart_type
        INNER JOIN chrt_lookup_lkp lkp_sub_type ON lkp_sub_type.pk_lkp_id = fk_lkp_cht_chart_sub_type
        WHERE pk_cht_id = i_chart_id
    );
END
$CODE$ language plpgsql