/*
This function just needs a VARCHAR type of any ID value with the following pattern "Alphabet-numeric", for example like :
G001, DEF00230001, AUTO19284
Basically the left side is alphabetic, while the right side is numeric. You can't mix something in between like :
AR01KEL0002 or G92TOP00234
This also won't work if you include any other symbol like "-", "_", etc. For example like :
GAME_000239, CAR-002-0049, etc.

This also works if the ID contains only number like 000923 or 001000492
Keep in mind, this function only reads the number and then +1 it
If your ID contains pattern like YYYYMMDD0001 like 202209180002, it will works, but on the next day (like 20 Sept 2022), it will still contain 20220918
*/

CREATE OR REPLACE FUNCTION IDGeneratorV1 (id_awal IN VARCHAR2)
RETURN VARCHAR2
AS
	prefix VARCHAR2(25) := '';
	panjang_prefix int;
	panjang_nomor int;
	nomor_terakhir number;
	nomor_nol VARCHAR2(25) := '0';
	nomor_nol_awal VARCHAR2(25);
	nomor_baru int;
	panjang_id int;
	counter int := 1;
	id_final VARCHAR2(50);
BEGIN
	-- Saving the length of whole ID into panjang_id
	SELECT LENGTH(id_awal) INTO panjang_id FROM dual;
	counter := 1;
	
	-- A loop where it basically tries to read what the prefix is and saving it to prefix variable
	LOOP
		IF ((LENGTH(TRIM(TRANSLATE((SUBSTR(id_awal,1,counter)),'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',' '))) IS NULL)) THEN
			prefix := (SUBSTR(id_awal,1,counter));
			counter := counter + 1;
		ELSE
			EXIT;
		END IF;
	END LOOP;
	
	-- Saving prefix length by subtracting 1 from the counter
	panjang_prefix := counter-1;
	-- Saving the length of numeric part by subtracting panjang_id with panjang_prefix
	panjang_nomor := panjang_id - panjang_prefix;
	-- Saving the last number from ID in numeric format (no longer char format). This will be used so we can +1 it
	nomor_terakhir := TO_NUMBER(SUBSTR(id_awal,(panjang_prefix + 1)));
	-- The new number, still in raw format (Not like 000094, but 94)
	nomor_baru := nomor_terakhir + 1;
	
	-- Resetting the counter back to 1
	counter := 1;
	
	/*
	This looping part basically making a bunch of zeros (000...) until the length of panjang_nomor
	For example, ID00029, then this will create 00000 (5 zeros)
	*/
	LOOP
		IF (LENGTH(nomor_nol) < panjang_nomor) THEN
			nomor_nol := nomor_nol||'0';
		ELSIF (LENGTH(nomor_nol) <= panjang_nomor) THEN
			EXIT;
		ELSE
			EXIT;
		END IF;
	END LOOP;
	
	-- Nomor_nol_awal is basically subtracting the previous "making zeros" part so we can add the new number after it
	nomor_nol_awal := SUBSTR(nomor_nol, 1, (panjang_nomor - LENGTH(nomor_baru)));
	-- The making of final ID, by placing the prefix first, then adding the zeros, then the last new number
	id_final := prefix||nomor_nol_awal||TO_CHAR(nomor_baru);
	-- Returning the new ID
	RETURN(id_final);
END;
