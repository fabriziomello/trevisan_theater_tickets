/***
 *
 * Microframework para testes de unidade em PL/pgSQL
 *
 */
DROP SCHEMA IF EXISTS test CASCADE;
CREATE SCHEMA test;

CREATE OR REPLACE FUNCTION test.assert_equals(
	IN 		expected 	ANYELEMENT,
	IN 		returned 	ANYELEMENT,
	OUT 	status 		TEXT,
	INOUT 	message 	TEXT
) AS
$$
BEGIN
	IF expected IS NULL THEN
		IF returned IS NOT NULL THEN
			status  := 'ERROR';
			message := format(message, COALESCE(expected::TEXT, '(null)'), returned);
		ELSE
			status  := 'OK';
			message := 'N/A';
		END IF;
	ELSE
		IF expected <> returned OR returned IS NULL THEN
			status  := 'ERROR';
			message := format(message, expected, COALESCE(returned::TEXT, '(null)'));
		ELSE
			status  := 'OK';
			message := 'N/A';
		END IF;
	END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TABLE test.results (
	id		SERIAL,
	test	TEXT,
	status	TEXT,
	message	TEXT
);

CREATE OR REPLACE FUNCTION test.add_assert_equals(TEXT, ANYELEMENT, ANYELEMENT, TEXT) RETURNS void
AS
$$
	INSERT INTO test.results(test, status, message)
	SELECT $1,
	       status,
		   message
	  FROM test.assert_equals($2, $3, $4);
$$
LANGUAGE sql;

