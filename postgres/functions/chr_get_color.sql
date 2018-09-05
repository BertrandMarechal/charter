CREATE OR REPLACE FUNCTION chr_get_color(i_opacity numeric default null) RETURNS TEXT
AS $CODE$
BEGIN
    RETURN 'rgba(' || floor(random() * 255) || ',' ||
        floor(random() * 255) || ',' ||
        floor(random() * 255) || ', ' || round(CAST(COALESCE(i_opacity,random()) as numeric), 2 ) || ')';
END
$CODE$ language plpgsql