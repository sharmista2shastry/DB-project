CREATE OR REPLACE FUNCTION PROCESS_TRANSACTION(
	email TEXT,
    card_number TEXT,
    amount INT,
	merchant_id INT,
	issuer_id INT,
	transaction_type INT
)
RETURNS BOOL
AS $$
DECLARE
	holder_id INT;
	bool1 BOOLEAN;
	bool2 BOOLEAN;
	bool3 BOOLEAN;
BEGIN
	SELECT (CD.CARDHOLDER_ID) INTO holder_id FROM CARDHOLDER_DETAILS CD WHERE CD.EMAIL = $1;
	
	SELECT (C.AVAILABLE_FUNDS >= $3) INTO bool1
	FROM CARDS C
	WHERE C.CARDHOLDER_ID = holder_id
	AND C.CARD_NUMBER = $2;

	SELECT (M.COUNTRY_ID = I.COUNTRY_ID) INTO bool2
	FROM MERCHANTS M
	JOIN ISSUERS I ON M.MERCHANT_ID = $4 AND I.ISSUER_ID = (SELECT C.ISSUER_ID FROM CARDS C
															WHERE C.CARDHOLDER_ID = holder_id
															AND C.CARD_NUMBER = $2);

	IF bool1 AND bool2 THEN
			SELECT COALESCE(PC.ONLINE_SHOPPING_DISCOUNT, FALSE) INTO bool3
			  FROM PLATINUM_CARDS PC
			  WHERE PC.CARDHOLDER_ID = holder_id AND PC.CARD_NUMBER = $2
			  UNION
			  SELECT COALESCE(TC.ONLINE_SHOPPING_DISCOUNT, FALSE)
			  FROM TITANIUM_CARDS TC
			  WHERE TC.CARDHOLDER_ID = holder_id AND TC.CARD_NUMBER = $2
			  LIMIT 1;
				IF bool3 THEN
					INSERT INTO TRANSACTIONS (AMOUNT, CURRENCY, FRAUD, TRANSACTION_STATUS, TRANSACTION_TIMESTAMP, MERCHANT_ID, ACQUIRER_ID, TRANSACTION_TYPE_ID, AUTHENTICATION_TYPE_ID, CARD_NUMBER, CARDHOLDER_ID) VALUES
					($3 * 0.9, 'USD', 'FALSE', 'TRUE', NOW(), $4, 1, $6, 1, $2, holder_id);
					UPDATE CARDS CDS SET AVAILABLE_FUNDS = AVAILABLE_FUNDS - $3 * 0.9 WHERE CDS.CARD_NUMBER = $2 AND CDS.CARDHOLDER_ID = holder_id;
				ELSE
					INSERT INTO TRANSACTIONS (AMOUNT, CURRENCY, FRAUD, TRANSACTION_STATUS, TRANSACTION_TIMESTAMP, MERCHANT_ID, ACQUIRER_ID, TRANSACTION_TYPE_ID, AUTHENTICATION_TYPE_ID, CARD_NUMBER, CARDHOLDER_ID) VALUES
					($3, 'USD', 'FALSE', 'TRUE', NOW(), $4, 1, $6, 1, $2, holder_id);
					UPDATE CARDS CDS SET AVAILABLE_FUNDS = AVAILABLE_FUNDS - $3 WHERE CDS.CARD_NUMBER = $2 AND CDS.CARDHOLDER_ID = holder_id;
				END IF;
	END IF;
	
	IF (NOT bool1) AND bool2 THEN
		INSERT INTO TRANSACTIONS (AMOUNT, CURRENCY, FRAUD, TRANSACTION_STATUS, TRANSACTION_TIMESTAMP, MERCHANT_ID, ACQUIRER_ID, TRANSACTION_TYPE_ID, DECLINE_REASON_ID, CARD_NUMBER, CARDHOLDER_ID) VALUES
			($3, 'USD', 'FALSE', 'FALSE', NOW(), $4, 1, $6, 1, $2, holder_id);
		RETURN FALSE;
	END IF;
	
	IF bool1 AND (NOT bool2) THEN
		INSERT INTO TRANSACTIONS (AMOUNT, CURRENCY, FRAUD, TRANSACTION_STATUS, TRANSACTION_TIMESTAMP, MERCHANT_ID, ACQUIRER_ID, TRANSACTION_TYPE_ID, CARD_NUMBER, CARDHOLDER_ID) VALUES
			($3, 'USD', 'TRUE', 'FALSE', NOW(), $4, 1, $6, $2, holder_id);
		RETURN FALSE;
	END IF;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- SELECT PROCESS_TRANSACTION('Veda Jorry', '1234-5696-3702-9692', 10000, 1, 1, 1)