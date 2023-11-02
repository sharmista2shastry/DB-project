CREATE OR REPLACE FUNCTION CreateToken(
    MerchantId VARCHAR(100),
    Country VARCHAR(100),
	CardNumber VARCHAR(100),
	Dater VARCHAR(100),
	Cardholder_Id VARCHAR(100)
) RETURNS text AS $$
DECLARE
    shifted_string1 VARCHAR(100);
    shifted_string2 VARCHAR(100);
    shifted_string3 VARCHAR(100);
    shifted_string4 VARCHAR(100);
	shifted_string5 VARCHAR(100);
    concatenated_string VARCHAR(100);
BEGIN
    -- Shift ASCII values by 9 for String1
    shifted_string1 := '';
    FOR i IN 1..length(MerchantId) LOOP
        shifted_string1 := shifted_string1 || chr((ascii(substring(MerchantId, i, 1)) + 1)::integer);
    END LOOP;

    -- Shift ASCII values by 9 for String2
    shifted_string2 := '';
    FOR i IN 1..length(Country) LOOP
        shifted_string2 := shifted_string2 || chr((ascii(substring(Country, i, 1)) + 1)::integer);
    END LOOP;

    -- Shift ASCII values by 9 for String3
    shifted_string3 := '';
    FOR i IN 1..length(CardNumber) LOOP
        shifted_string3 := shifted_string3 || chr((ascii(substring(CardNumber, i, 1)) + 1)::integer);
    END LOOP;

    -- Shift ASCII values by 9 for String4
    shifted_string4 := '';
    FOR i IN 1..length(Dater) LOOP
        shifted_string4 := shifted_string4 || chr((ascii(substring(Dater, i, 1)) + 1)::integer);
    END LOOP;
	
	shifted_string5 := '';
    FOR i IN 1..length(Cardholder_Id) LOOP
        shifted_string5 := shifted_string5 || chr((ascii(substring(Cardholder_Id, i, 1)) + 1)::integer);
    END LOOP;

    -- Concatenate the shifted strings with hyphens every 4 characters
    concatenated_string := shifted_string1 || '-' || shifted_string2  || '-' || shifted_string3  || '-' || shifted_string4  || '-' || shifted_string5;
   
    RETURN concatenated_string;
END;
$$ LANGUAGE plpgsql;