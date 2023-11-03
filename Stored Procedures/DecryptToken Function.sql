CREATE OR REPLACE FUNCTION DecryptToken(
    input_string text
) RETURNS TABLE (split_text1 text, split_text2 text, split_text3 text, split_text4 text, split_text5 text) AS $$
DECLARE
    split_strings text[];
    i integer;
    split_text1 text := '';
    split_text2 text := '';
    split_text3 text := '';
    split_text4 text := '';
	split_text5 text := '';
BEGIN
	split_strings := string_to_array(input_string, '-');

    -- Split the input_string based on hyphens
    
    -- Reverse the shift operation for each split part and assign to variables
    FOR i IN 1..array_length(split_strings, 1) LOOP
        CASE i
            WHEN 1 THEN
                FOR j IN 1..length(split_strings[i]) LOOP
                    split_text1 := split_text1 || chr((ascii(substring(split_strings[i], j, 1)) - 1)::integer);
                END LOOP;
            WHEN 2 THEN
                FOR j IN 1..length(split_strings[i]) LOOP
                    split_text2 := split_text2 || chr((ascii(substring(split_strings[i], j, 1)) - 1)::integer);
                END LOOP;
            WHEN 3 THEN
                FOR j IN 1..length(split_strings[i]) LOOP
                    split_text3 := split_text3 || chr((ascii(substring(split_strings[i], j, 1)) - 1)::integer);
                END LOOP;
            WHEN 4 THEN
                FOR j IN 1..length(split_strings[i]) LOOP
                    split_text4 := split_text4 || chr((ascii(substring(split_strings[i], j, 1)) - 1)::integer);
                END LOOP;
			WHEN 5 THEN
                FOR j IN 1..length(split_strings[i]) LOOP
                    split_text5 := split_text5 || chr((ascii(substring(split_strings[i], j, 1)) - 1)::integer);
                END LOOP;
        END CASE;
    END LOOP;
    RETURN QUERY SELECT split_text1, split_text2, split_text3, split_text4, split_text5;
END;
$$ LANGUAGE plpgsql;