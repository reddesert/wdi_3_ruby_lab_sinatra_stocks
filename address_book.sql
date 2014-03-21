DROP TABLE people;

CREATE TABLE people (id SERIAL PRIMARY KEY, name TEXT, phone TEXT);

INSERT INTO people (name, phone) VALUES ('David', '978-555-5555')