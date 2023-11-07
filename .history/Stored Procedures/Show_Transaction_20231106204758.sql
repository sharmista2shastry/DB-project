CREATE OR REPLACE FUNCTION GET_SUCCESSFUL_TRANSACTIONS_BY_EMAIL(customer_email TEXT)
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
    cardholder_id INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        T.TRANSACTION_ID,
        T.AMOUNT,
        T.CURRENCY,
        T.FRAUD,
        DATE(T.TRANSACTION_TIMESTAMP),
        T.MERCHANT_ID,
        T.ACQUIRER_ID,
        T.TRANSACTION_TYPE_ID,
        T.DECLINE_REASON_ID,
        T.AUTHENTICATION_TYPE_ID,
        T.CARD_NUMBER,
        T.CARDHOLDER_ID
    FROM
        TRANSACTIONS T
    JOIN
        CARDHOLDER_DETAILS CD ON T.CARDHOLDER_ID = CD.CARDHOLDER_ID
    WHERE
        CD.EMAIL = customer_email
        AND T.TRANSACTION_STATUS = TRUE;
END;
$$ LANGUAGE plpgsql;
