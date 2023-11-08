CREATE OR REPLACE FUNCTION CREATE_AND_SAVE_TOKEN(
    MerchantId TEXT,
    Country TEXT,
	CardNumber TEXT,
	Dater TEXT,
	Cardholder_Id TEXT,
	CustomerEmail TEXT
) RETURNS text AS $$
DECLARE
    shifted_string1 VARCHAR(100);
    shifted_string2 VARCHAR(100);
    shifted_string3 VARCHAR(100);
    shifted_string4 VARCHAR(100);
	shifted_string5 VARCHAR(100);
    concatenated_string VARCHAR(100);
	card_token_id INT;
BEGIN
    -- Shift ASCII values by 9 for String1
    shifted_string1 := '';
    FOR i IN 1..length(MerchantId) LOOP
        shifted_string1 := shifted_string1 || chr((ascii(substring(MerchantId, i, 1)) + 1)::integer);
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
   
    INSERT INTO INTERNETFLIX_STORED_CARD_DATA(CARD_TOKEN, MERCHANT_ID) VALUES (concatenated_string, 1);
	
	card_token_id = (SELECT STORED_CARD_ID FROM INTERNETFLIX_STORED_CARD_DATA WHERE CARD_TOKEN = concatenated_string);
	
	UPDATE INTERNETFLIX_CUSTOMER_DATA SET STORED_CARD_ID = card_token_id WHERE CUSTOMER_EMAIL = $6;

    RETURN concatenated_string;
END;
$$ LANGUAGE plpgsql;

-- SELECT CREATE_AND_SAVE_TOKEN(CAST('1' AS TEXT), CAST('1' AS TEXT), CAST('1234-5614-9008-0533' AS TEXT), TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD'), CAST (105 AS TEXT), CAST('bbartos2w@jigsy.com' AS TEXT));