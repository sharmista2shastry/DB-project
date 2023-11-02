CREATE OR REPLACE FUNCTION insert_unsuccessful_transactions_for_cards()
RETURNS void AS
$$
DECLARE
    card_row RECORD;
	random_num INT := 0;
	loop_counter INT :=0;
	rand_multiplier INT := 0;
BEGIN
    -- Declare a cursor to iterate through the CARDS table
    FOR card_row IN (SELECT * FROM CARDS) LOOP
		random_num := floor(random() * 3);
		-- Add 10 to the random number to get a range between 10 and 20
		WHILE loop_counter < random_num LOOP
			rand_multiplier := floor(random() * 100);
			-- Insert a row in the TRANSACTIONS table for each card
			INSERT INTO TRANSACTIONS (AMOUNT, CURRENCY, FRAUD, TRANSACTION_STATUS, TRANSACTION_TIMESTAMP, MERCHANT_ID, ACQUIRER_ID, TRANSACTION_TYPE_ID, CARD_NUMBER, CARDHOLDER_ID, AUTHENTICATION_TYPE_ID, DECLINE_REASON_ID)
			VALUES (
				-- Replace with appropriate values for each transaction
				random_num * rand_multiplier + 1, -- Example: Amount
				'USD',  -- Example: Currency
				FALSE,  -- Example: Fraud status
				FALSE,   -- Example: Transaction status
				NOW(),  -- Example: Transaction timestamp
				1,      -- Example: Merchant ID
				floor(random() * 5) + 1,      -- Example: Acquirer ID
				3,      -- Example: Transaction Type ID
				card_row.CARD_NUMBER, -- Use CARD_NUMBER from the current card
				card_row.CARDHOLDER_ID, -- Use CARDHOLDER_ID from the current card
				floor(random() * 5) + 1,
				floor(random() * 2) + 1
			);
			loop_counter := loop_counter + 1;
		END LOOP;
		loop_counter = 0;
    END LOOP;

    RETURN;
END;
$$
LANGUAGE plpgsql;

-- Call the stored procedure to insert transactions for cards
SELECT insert_unsuccessful_transactions_for_cards();
