-- CREATE DATABASE travel_agency;

-- CREATE TABLE client (
--     ID_client SERIAL PRIMARY KEY,
--     Name VARCHAR(100) NOT NULL,
--     Surname VARCHAR(100) NOT NULL,
--     Tel VARCHAR(20),
--     Email VARCHAR(100) UNIQUE,
--     Passport VARCHAR(50) NOT NULL UNIQUE
-- );

-- CREATE TABLE country (
--     ID_country SERIAL PRIMARY KEY,
--     Country_Name VARCHAR(100) NOT NULL,
--     Visa_price DECIMAL(10, 2) CHECK (Visa_price >= 0)
-- );

-- CREATE TABLE tour (
--     ID_tour SERIAL PRIMARY KEY,
--     Tour_name VARCHAR(100) NOT NULL,
--     Tour_price DECIMAL(10, 2) CHECK (Tour_price >= 0),
--     Purpose_of_trip TEXT,
--     ID_country INT NOT NULL,
--     CONSTRAINT fk_country
--         FOREIGN KEY (ID_country) 
--         REFERENCES Country(ID_country)
--         ON DELETE CASCADE
-- );

-- CREATE TABLE tourSale (
--     ID_tourSale SERIAL PRIMARY KEY,
--     Date_of_sale DATE NOT NULL,
--     ID_client INT NOT NULL,
--     ID_tour INT NOT NULL,
--     CONSTRAINT fk_client
--         FOREIGN KEY (ID_client) 
--         REFERENCES Client(ID_client)
--         ON DELETE CASCADE,
--     CONSTRAINT fk_tour
--         FOREIGN KEY (ID_tour) 
--         REFERENCES Tour(ID_tour)
--         ON DELETE CASCADE
-- );
-- ====================================================================================

INSERT INTO client (Name, Surname, Tel, Email, Passport)
VALUES
('Ivan', 'Ivanov', '+380501234567', 'ivanov@example.com', 'AA123456'),
('Olga', 'Petrova', '+380631234567', 'petrova@example.com', 'BB654321'),
('Dmytro', 'Shevchenko', '+380671234567', 'shevchenko@example.com', 'CC987654'),
('Anna', 'Zhuk', '+380931234567', 'zhuk@example.com', 'DD111222'),
('Yulia', 'Kovalenko', '+380441234567', 'kovalenko@example.com', 'EE333444');

INSERT INTO country (Country_Name, Visa_price)
VALUES
('Italy', 60.00),
('France', 70.00),
('Germany', 50.00),
('Spain', 65.00),
('Japan', 80.00);

INSERT INTO tour (Tour_name, Tour_price, Purpose_of_trip, id_country)
VALUES
('Romantic Venice', 1200.00, 'Honeymoon', 1),
('Parisian Dreams', 1500.00, 'Romantic Getaway', 2),
('Berlin Adventure', 900.00, 'City Tour', 3),
('Spanish Fiesta', 1100.00, 'Cultural Tour', 4),
('Cherry Blossom Japan', 2000.00, 'Nature Exploration', 5);

INSERT INTO tourSale (Date_of_sale, ID_client, ID_tour)
VALUES
('2024-01-15', 1, 1),
('2024-02-20', 2, 2),
('2024-03-10', 3, 3),
('2024-04-25', 4, 4),
('2024-05-30', 5, 5);
-- =======================================

SELECT * FROM client;

SELECT * FROM country;

SELECT * FROM tour;

SELECT * FROM tourSale;

-- =======================================

-- Відобразити інформацію про замовлення конкретного клієнта
SELECT Tour.Tour_name, Tour.Tour_price, TourSale.Date_of_sale
FROM TourSale
JOIN Tour ON TourSale.ID_tour = Tour.ID_tour
JOIN Client ON TourSale.ID_client = Client.ID_client
WHERE Client.Name = 'Ivan' AND Client.Surname = 'Ivanov'; 

-- Перелік турів, оформлених сьогодні
SELECT Tour.Tour_name, Client.Name, Client.Surname, TourSale.Date_of_sale
FROM TourSale
JOIN Tour ON TourSale.ID_tour = Tour.ID_tour
JOIN Client ON TourSale.ID_client = Client.ID_client
WHERE TourSale.Date_of_sale = CURRENT_DATE;


-- Сумарна вартість замовлень кожного клієнта
SELECT Client.Name, Client.Surname, SUM(Tour.Tour_price) AS TotalSpent
FROM TourSale
JOIN Client ON TourSale.ID_client = Client.ID_client
JOIN Tour ON TourSale.ID_tour = Tour.ID_tour
GROUP BY Client.Name, Client.Surname;

-- Перелік продажів за конкретний тиждень
SELECT Tour.Tour_name, Client.Name, Client.Surname, TourSale.Date_of_sale
FROM TourSale
JOIN Tour ON TourSale.ID_tour = Tour.ID_tour
JOIN Client ON TourSale.ID_client = Client.ID_client
WHERE TourSale.Date_of_sale BETWEEN '2024-02-20' AND '2024-03-10'; 

-- Топ 5 турів за рік (за кількістю продажів)
SELECT Tour.Tour_name, COUNT(TourSale.ID_tour) AS SalesCount
FROM TourSale
JOIN Tour ON TourSale.ID_tour = Tour.ID_tour
WHERE DATE_TRUNC('year', TourSale.Date_of_sale) = DATE_TRUNC('year', CURRENT_DATE)
GROUP BY Tour.Tour_name
ORDER BY SalesCount DESC
LIMIT 5;
