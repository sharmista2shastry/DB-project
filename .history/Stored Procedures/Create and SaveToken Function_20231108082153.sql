CREATE OR REPLACE FUNCTION CREATE_AND_SAVE_TOKEN(
    MerchantId varchar(100),
	CardNumber varchar(100),
	CustomerEmail varchar(100)
) RETURNS text AS $$
DECLARE
    cardholder_id VARCHAR(100);
    shifted_string1 VARCHAR(100);
    shifted_string3 VARCHAR(100);
    shifted_string4 VARCHAR(100);
	shifted_string5 VARCHAR(100);
    concatenated_string VARCHAR(100);
	card_token_id INT;
    datesr VARCHAR(100);
BEGIN

    SELECT (CD.CARDHOLDER_ID::text) INTO cardholder_id FROM CARDHOLDER_DETAILS CD WHERE CD.EMAIL = $3;

    SELECT (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD')) INTO datesr;

    shifted_string1 := '';
    FOR i IN 1..length(MerchantId) LOOP
        shifted_string1 := shifted_string1 || chr((ascii(substring(MerchantId, i, 1)) + 1)::integer);
    END LOOP;
     
    shifted_string3 := '';
    FOR i IN 1..length(CardNumber) LOOP
        shifted_string3 := shifted_string3 || chr((ascii(substring(CardNumber, i, 1)) + 1)::integer);
    END LOOP;

    shifted_string4 := '';
    FOR i IN 1..length(datesr) LOOP
        shifted_string4 := shifted_string4 || chr((ascii(substring(datesr, i, 1)) + 1)::integer);
    END LOOP;
	
	shifted_string5 := '';
    FOR i IN 1..length(cardholder_id) LOOP
        shifted_string5 := shifted_string5 || chr((ascii(substring(cardholder_id, i, 1)) + 1)::integer);
    END LOOP;

    concatenated_string := shifted_string1 || '-' || shifted_string3  || '-' || shifted_string4  || '-' || shifted_string5;
   
    INSERT INTO INTERNETFLIX_STORED_CARD_DATA(CARD_TOKEN, MERCHANT_ID) VALUES (concatenated_string, 1);
	
	card_token_id = (SELECT STORED_CARD_ID FROM INTERNETFLIX_STORED_CARD_DATA WHERE CARD_TOKEN = concatenated_string);
	
	UPDATE INTERNETFLIX_CUSTOMER_DATA SET STORED_CARD_ID = card_token_id WHERE CUSTOMER_EMAIL = $3;

    RETURN concatenated_string;
END;
$$ LANGUAGE plpgsql;

SELECT CREATE_AND_SAVE_TOKEN('1','4652-2125-0227-2528','mmeates5@godaddy.com');
