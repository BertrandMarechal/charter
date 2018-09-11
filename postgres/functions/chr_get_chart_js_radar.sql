CREATE OR REPLACE FUNCTION chr_get_chart_js_radar(i_chart_id INT) RETURNS json
AS $CODE$
DECLARE
    v_labels_column_name TEXT;
    v_series_column_name TEXT;
    v_values_column_name TEXT;
    v_chart_name TEXT;
    v_query TEXT;
    v_series TEXT[];
    v_labels TEXT[];
    v_data numeric[];
    v_background_colors TEXT[];
    v_border_colors TEXT[];
BEGIN

    SELECT
        cht_name,
        cht_labels_column_name,
        cht_series_column_name,
        cht_values_column_name,
        cht_query
    INTO
        v_chart_name,
        v_labels_column_name,
        v_series_column_name,
        v_values_column_name,
        v_query
    FROM chrt_chart_cht
    WHERE pk_cht_id = i_chart_id;
    
    DELETE FROM chrt_chart_data_chd
    WHERE fk_cht_chd_chart_id = i_chart_id;
    
    EXECUTE 'INSERT INTO chrt_chart_data_chd(
        fk_cht_chd_chart_id,
        chd_serie_name,
        chd_label_name,
        chd_value
    )
    SELECT
        ' || i_chart_id || ',
        serie,
        abs,
        ord
    FROM (' || v_query || ') a';
    
    RETURN (
        json_build_object(
            'type', 'radar',
            'data', json_build_object(
                'labels', (
                        SELECT array_agg(chd_label_name)
                        FROM (
                                SELECT distinct chd_label_name
                                FROM chrt_chart_data_chd
                                WHERE fk_cht_chd_chart_id = i_chart_id
                                GROUP BY chd_label_name
                                ORDER BY chd_label_name
                        ) l
                ),
                'datasets', (
                        select array_agg(agg)
                        FROM (
                                select json_build_object(
                                        'label', chd_serie_name,
                                        'data', array_agg(chd_value ORDER BY(chd_label_name)),
                                        'backgroundColor', (SELECT array_agg(chr_get_color(0.5))),
                                        'borderColor', (SELECT array_agg(chr_get_color(1))),
                                        'borderWidth',1
                                ) agg
                                from chrt_chart_data_chd
                                WHERE fk_cht_chd_chart_id = i_chart_id
                                GROUP BY chd_serie_name--, chd_label_name
                        ) d
                )
            ),
            'options', json_build_object(
                'scales', json_build_object(
                    'yAxes', (
                        SELECT json_agg(
                            json_build_object(
                                'ticks', json_build_object(
                                    'beginAtZero', true
                                )
                            )
                        )
                    )
                )
            )
        )
    );
END
$CODE$ language plpgsql