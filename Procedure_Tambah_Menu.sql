CREATE OR REPLACE PROCEDURE TambahMenu(nama IN VARCHAR2, desk IN VARCHAR2, jenis IN VARCHAR2, harga IN int)
AS
	id_baru char(4);
	pesan VARCHAR2(100);
	checker int;
	id_jenis char(3);
BEGIN
	SELECT IDGeneratorV1(test) INTO id_baru FROM (
		SELECT MAX(ID_MENU) test FROM MENU
	);
	
	SELECT COUNT(ID_JEN_MENU) INTO checker
	FROM KATEGORI
	WHERE LOWER(jenis) = LOWER(NAMA_JEN_MENU);

	IF (checker = 1) THEN
		SELECT ID_JEN_MENU INTO id_jenis
		FROM KATEGORI
		WHERE LOWER(jenis) = LOWER(NAMA_JEN_MENU);
	ELSE
		NULL;
	END IF;
	
	IF (LENGTH(nama) < 3 OR MOD(harga, 500) != 0 OR checker != 1) THEN
		pesan := 'Mohon maaf, nama atau harga menyalahi aturan!';
		dbms_output.put_line(pesan);
	ELSE
		INSERT INTO MENU VALUES (id_baru, id_jenis, INITCAP(nama), harga, desk, null);
		COMMIT;
		pesan := 'Menu '||INITCAP(nama)||' berhasil ditambah!';
		dbms_output.put_line(pesan);
	END IF;
END;