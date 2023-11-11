CREATE OR REPLACE FUNCTION GET_TRANSACTIONS_BY_EMAIL(customer_email TEXT)
RETURNS TABLE (
    transaction_id INT,
    transaction_amount REAL,
    transaction_currency VARCHAR(100),
    transaction_fraud BOOLEAN,
    transaction_timestamp DATE,
    merchant_id INT,
    acquirer_id INT,
    transaction_type_id INT,
    decline_reason_id INT,
    authentication_type_id INT,
    card_number VARCHAR(30),
    cardholder_id INT,
	authentication_mechanism VARCHAR(100),
	transaction_type VARCHAR(100),
	MERCHANT_NAME VARCHAR(100),
    transaction_status BOOLEAN
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        T.TRANSACTION_ID,
        T.AMOUNT,
        T.CURRENCY,
        T.FRAUD,
        T.TRANSACTION_TIMESTAMP,
        T.MERCHANT_ID,
        T.ACQUIRER_ID,
        T.TRANSACTION_TYPE_ID,
        T.DECLINE_REASON_ID,
        T.AUTHENTICATION_TYPE_ID,
        T.CARD_NUMBER,
        T.CARDHOLDER_ID,
		AT.AUTHENTICATION_MECHANISM,
		TT.TRANSACTION_TYPE_NAME,
		M.MERCHANT_NAME,
        T.TRANSACTION_STATUS
    FROM
        TRANSACTIONS T
    JOIN
        CARDHOLDER_DETAILS CD ON T.CARDHOLDER_ID = CD.CARDHOLDER_ID
        JOIN MERCHANTS M ON M.MERCHANT_ID = T.MERCHANT_ID
        LEFT JOIN AUTHENTICATION_TYPES AT ON AT.AUTHENTICATION_TYPE_ID = T.AUTHENTICATION_TYPE_ID
		JOIN TRANSACTION_TYPES TT ON TT.TRANSACTION_TYPE_ID = T.TRANSACTION_TYPE_ID
    WHERE
        CD.EMAIL = customer_email
    ORDER BY T.TRANSACTION_TIMESTAMP DESC;
END;
$$ LANGUAGE plpgsql;