DROP SCHEMA IF EXISTS theater_dojo CASCADE;
CREATE SCHEMA theater_dojo;

SET search_path TO theater_dojo;

CREATE TYPE ticket_type AS
	ENUM ('Criança', 'Estudante', 'Idoso');

CREATE TYPE day_of_week AS
	ENUM ('Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado');

CREATE DOMAIN ticket_price AS
	NUMERIC (5, 2)
	CONSTRAINT ticket_price_ck
		CHECK (VALUE >= 0);

CREATE DOMAIN ticket_discount AS
	NUMERIC(3)
	CONSTRAINT ticket_discount_ck
		CHECK (VALUE BETWEEN 0 AND 100);

CREATE TABLE ticket_price_table (
	type 		ticket_type,
	price		ticket_price,
	CONSTRAINT ticket_price_pk
		PRIMARY KEY (type)
);

INSERT INTO ticket_price_table
	VALUES	('Criança',		5.50),
			('Estudante',	8.00),
			('Idoso',		6.00);

CREATE TABLE ticket_discount_table (
	day_of_week	day_of_week,
	type 		ticket_type,
	discount 	ticket_discount,
	CONSTRAINT ticket_discount_table_pk
		PRIMARY KEY (day_of_week, type)
);

INSERT INTO ticket_discount_table
			/* Domingo */
	VALUES	('Domingo',	'Idoso',		5.00),
			/* Segunda */
			('Segunda',	'Criança',		10.00),
			('Segunda',	'Estudante',	10.00),
			('Segunda',	'Idoso',		10.00),
			/* Terça */
			('Terça',	'Criança',		15.00),
			('Terça',	'Estudante',	5.00),
			('Terça',	'Idoso',		15.00),
			/* Quarta */
			('Quarta',	'Criança',		30.00),
			('Quarta',	'Estudante',	50.00),
			('Quarta',	'Idoso',		40.00),
			/* Quinta */
			('Quinta',	'Estudante',	30.00),
			('Quinta',	'Idoso',		30.00),
			/* Sexta */
			('Sexta',	'Criança',		11.00),
			/* Sábado */
			('Sábado',	'Idoso',		5.00);


CREATE FUNCTION getTicketPrice(ticket_type)
RETURNS ticket_price AS
$$
	SELECT price
	  FROM theater_dojo.ticket_price_table
	 WHERE type = $1;
$$
LANGUAGE sql;

CREATE FUNCTION getTicketDiscount(day_of_week, ticket_type, BOOLEAN)
RETURNS ticket_discount AS
$$
	SELECT
		CASE
			-- Student Card is Used?
			WHEN $3 IS TRUE AND $1 NOT IN ('Domingo', 'Sábado') THEN
				35.00
			ELSE
				(SELECT discount
		  		   FROM theater_dojo.ticket_discount_table
		 		  WHERE day_of_week = $1
			 	    AND type        = $2)
		END;
$$
LANGUAGE sql;

CREATE FUNCTION getTicketDiscount(day_of_week, ticket_type)
RETURNS ticket_discount AS
$$
	SELECT theater_dojo.getTicketDiscount($1, $2, FALSE);
$$
LANGUAGE sql;
