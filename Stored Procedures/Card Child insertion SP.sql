CREATE OR REPLACE FUNCTION insert_CHILD_cards()
RETURNS void AS
$$
DECLARE
    card_row RECORD;
	random_num INT := 0;
	rand_1 INT := 0;
	val_1 BOOL := false;
	rand_2 INT := 0;
	val_2 BOOL := false;
	rand_3 INT := 0;
	val_3 BOOL := false;
BEGIN
    -- Declare a cursor to iterate through the CARDS table
    FOR card_row IN (SELECT * FROM CARDS) LOOP
		random_num := floor(random() * 3);
		
		rand_1 := random();
		IF rand_1 >= 0.5 THEN val_1 = true; END IF;
		rand_2 := random();
		IF rand_2 >= 0.5 THEN val_2 = true; END IF;
		rand_3 := random();
		IF rand_3 >= 0.5 THEN val_3 = true; END IF;
		
		IF random_num<1 THEN
			INSERT INTO DIAMOND_CARDS (CARD_NUMBER, CARDHOLDER_ID, LOUNGE_ACCESS, GOLF_BENEFITS, VALET_PARKING) VALUES (
				card_row.CARD_NUMBER, -- Use CARD_NUMBER from the current card
				card_row.CARDHOLDER_ID, -- Use CARDHOLDER_ID from the current card
				val_1,
				val_2,
				val_3
			);
		ELSIF random_num<2 THEN
			INSERT INTO TITANIUM_CARDS (CARD_NUMBER, CARDHOLDER_ID, LOUNGE_ACCESS, CINEMA_DISCOUNT, ONLINE_SHOPPING_DISCOUNT) VALUES (
				card_row.CARD_NUMBER, -- Use CARD_NUMBER from the current card
				card_row.CARDHOLDER_ID, -- Use CARDHOLDER_ID from the current card
				val_1,
				val_2,
				val_3
			);
		ELSE
			INSERT INTO PLATINUM_CARDS (CARD_NUMBER, CARDHOLDER_ID, CINEMA_DISCOUNT, ONLINE_SHOPPING_DISCOUNT) VALUES (
				card_row.CARD_NUMBER, -- Use CARD_NUMBER from the current card
				card_row.CARDHOLDER_ID, -- Use CARDHOLDER_ID from the current card
				val_1,
				val_2
			);
		END IF;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

-- Call the stored procedure to insert transactions for cards
SELECT insert_CHILD_cards();
