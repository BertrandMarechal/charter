CREATE OR REPLACE FUNCTION chr_get_chart_js_pie(i_chart_id INT) RETURNS json
AS $CODE$
DECLARE
    v_labels_column_name TEXT;
    v_values_column_name TEXT;
    v_chart_name TEXT;
    v_query TEXT;
    v_series TEXT[];
    v_data numeric[];
    v_background_colors TEXT[];
    v_border_colors TEXT[];
BEGIN

    SELECT
        cht_name,
        cht_labels_column_name,
        cht_values_column_name,
        cht_query
    INTO
        v_chart_name,
        v_labels_column_name,
        v_values_column_name,
        v_query
    FROM chrt_chart_cht
    WHERE pk_cht_id = i_chart_id;

    EXECUTE 'CREATE LOCAL TEMP TABLE temp_chart_data_' || i_chart_id || '
    ON COMMIT DROP AS ' || v_query;

    EXECUTE 'SELECT array_agg("' || v_labels_column_name || '") FROM temp_chart_data_' || i_chart_id INTO v_series;
    EXECUTE 'SELECT array_agg("' || v_values_column_name || '") FROM temp_chart_data_' || i_chart_id INTO v_data;
    EXECUTE 'SELECT array_agg(chr_get_color(0.5)) FROM temp_chart_data_' || i_chart_id INTO v_background_colors;
    EXECUTE 'SELECT array_agg(chr_get_color(1)) FROM temp_chart_data_' || i_chart_id INTO v_border_colors;

    RETURN (
        json_build_object(
            'type', 'pie',
            'data', json_build_object(
                'labels', v_series,
                'datasets', (
                    SELECT json_agg(
                        json_build_object(
                            'label',v_chart_name,
                            'data',v_data,
                            'backgroundColor',v_background_colors,
                            'borderColor',v_border_colors,
                            'borderWidth',1
                        )
                    )
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