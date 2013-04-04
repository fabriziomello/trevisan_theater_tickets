/* Casos de testes */

SELECT test.add_assert_equals(
			E'Verifica se esquema \"theater_dojo\" existe',
			TRUE,
			EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = 'theater_dojo'),
			E'Esquema \"theater_dojo\" não existe'
		);

SELECT test.add_assert_equals(
			E'Verifica se tipo de dados \"ticket_type\" existe',
			TRUE,
			EXISTS(SELECT 1 FROM pg_type WHERE typname = 'ticket_type' AND typcategory = 'E'),
			E'Tipo de dado \"ticket_type\" não existe'
		);

SELECT test.add_assert_equals(
			E'Verifica se tabela \"ticket_price\" existe',
  			TRUE,
			EXISTS(SELECT 1 FROM pg_class WHERE relname = 'ticket_price' AND relkind = 'r'),
			E'Tabela \"ticket_price\" não existe'
		);

SELECT test.add_assert_equals(
			E'Verifica se tabela \"ticket_discount\" existe',
  			TRUE,
			EXISTS(SELECT 1 FROM pg_class WHERE relname = 'ticket_discount' AND relkind = 'r'),
			E'Tabela \"ticket_discount\" não existe'
		);

SELECT test.add_assert_equals(
			E'Verifica valor dos ingressos para Crianças',
  			5.5,
			getTicketPrice('Criança'),
			E'Valor do ingresso esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica valor dos ingressos para Estudantes',
  			8.00,
			getTicketPrice('Estudante'),
			E'Valor do ingresso esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica valor dos ingressos para Idosos',
  			6.00,
			getTicketPrice('Idoso'),
			E'Valor do ingresso esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica desconto dos ingressos para Crianças aos Domingos',
  			NULL,
			getTicketDiscount('Domingo', 'Criança'),
			E'Valor do desconto esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica desconto dos ingressos para Idosos aos Domingos',
  			5.00,
			getTicketDiscount('Domingo', 'Idoso'),
			E'Valor do desconto esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica desconto dos ingressos para Estudantes as Terças',
  			5.00,
			getTicketDiscount('Terça', 'Estudante'),
			E'Valor do desconto esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica desconto dos ingressos apresentando Carteira de Estudante aos Domingos',
  			NULL,
			getTicketDiscount('Domingo', 'Estudante', TRUE),
			E'Valor do desconto esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica desconto dos ingressos apresentando Carteira de Estudante as Quartas',
  			35.00,
			getTicketDiscount('Quarta', 'Idoso', TRUE),
			E'Valor do desconto esperado era de %s mas foi retornado %s'
		);

SELECT test.add_assert_equals(
			E'Verifica desconto dos ingressos apresentando Carteira de Estudante as Sextas',
  			35.00,
			getTicketDiscount('Sexta', 'Estudante', TRUE),
			E'Valor do desconto esperado era de %s mas foi retornado %s'
		);

