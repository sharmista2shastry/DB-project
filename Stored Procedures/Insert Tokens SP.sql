CREATE OR REPLACE FUNCTION INSERT_TOKENS()
RETURNS void AS
$$
DECLARE
    card_row RECORD;
    card_row2 RECORD;
    card_token text;
BEGIN
    FOR card_row IN (SELECT * FROM INTERNETFLIX_CUSTOMER_DATA) LOOP
		IF card_row.CUSTOMER_ID <= 660 THEN 
                FOR card_row2 IN (SELECT * FROM CARDHOLDER_DETAILS CD JOIN CARDS C ON CD.CARDHOLDER_ID = C.CARDHOLDER_ID WHERE CD.EMAIL = card_row.customer_email) LOOP
                    card_token = CreateToken('1','1', CAST(card_row2.CARD_NUMBER AS VARCHAR), TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD'), CAST(card_row2.CARDHOLDER_ID AS VARCHAR));
                    INSERT INTO INTERNETFLIX_STORED_CARD_DATA (CARD_TOKEN, MERCHANT_ID) VALUES (
                            card_token,
                            1
                    ); 
                END LOOP;
        END IF;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;