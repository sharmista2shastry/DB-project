CREATE OR REPLACE FUNCTION INSERT_USERS()
RETURNS void AS
$$
DECLARE
    card_row RECORD;
    card_token text;
    counter_num int;
BEGIN
    counter_num=1;
    FOR card_row IN (SELECT * FROM CARDHOLDER_DETAILS CD) LOOP
		IF random() >= 0.5 THEN 
                            INSERT INTO INTERNETFLIX_CUSTOMER_DATA (CUSTOMER_NAME, CUSTOMER_ADDRESS, CUSTOMER_EMAIL) VALUES (
                    card_row.CARDHOLDER_NAME,
                    'this is an address',
                    card_row.EMAIL                );  
        END IF;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;