CREATE OR REPLACE FUNCTION chr_get_chart(i_chart INT) RETURNS json
AS $CODE$
BEGIN
    RETURN (
        json_build_object(
            'type', 'bar',
            'data', json_build_object(
                'labels', (
                    SELECT json_agg(color)
                    FROM (
                        SELECT 'Red' color UNION ALL
                        SELECT 'Blue' color UNION ALL
                        SELECT 'Yellow' color UNION ALL
                        SELECT 'Green' color UNION ALL
                        SELECT 'Purple' color UNION ALL
                        SELECT 'Orange' color
                    ) a
                ),
                'datasets', (
                    SELECT json_agg(
                        json_build_object(
                            'label','# of votes',
                            'data',(
                                SELECT json_agg(r)
                                FROM (
                                    SELECT floor(random() * 30 + 1) r UNION ALL
                                    SELECT floor(random() * 30 + 1) r UNION ALL
                                    SELECT floor(random() * 30 + 1) r UNION ALL
                                    SELECT floor(random() * 30 + 1) r UNION ALL
                                    SELECT floor(random() * 30 + 1) r UNION ALL
                                    SELECT floor(random() * 30 + 1) r
                                ) a
                            ),
                            'backgroundColor',(
                                SELECT json_agg(r)
                                FROM (
                                    SELECT chr_get_color(1) r UNION ALL
                                    SELECT chr_get_color(1) r UNION ALL
                                    SELECT chr_get_color(1) r UNION ALL
                                    SELECT chr_get_color(1) r UNION ALL
                                    SELECT chr_get_color(1) r UNION ALL
                                    SELECT chr_get_color(1) r
                                ) a
                            ),
                            'borderColor',(
                                SELECT json_agg(r)
                                FROM (
                                    SELECT chr_get_color(0.5) r UNION ALL
                                    SELECT chr_get_color(0.5) r UNION ALL
                                    SELECT chr_get_color(0.5) r UNION ALL
                                    SELECT chr_get_color(0.5) r UNION ALL
                                    SELECT chr_get_color(0.5) r UNION ALL
                                    SELECT chr_get_color(0.5) r
                                ) a
                            ),
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
                                    'beginAtZero', true,
                                    'suggestedMax', 30
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