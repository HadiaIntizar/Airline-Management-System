create database airways;
use airways;
CREATE TABLE Airlines (
    airline_id INT PRIMARY KEY,
    name VARCHAR(100),
    country VARCHAR(100)
);
CREATE TABLE Aircrafts (
    aircraft_id INT PRIMARY KEY,
    model VARCHAR(100),
    capacity INT,
    airline_id INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);
CREATE TABLE Airports (
    airport_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100)
);
CREATE TABLE Routes (
    route_id INT PRIMARY KEY,
    source_airport_id INT,
    destination_airport_id INT,
    FOREIGN KEY (source_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (destination_airport_id) REFERENCES Airports(airport_id)
);
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    airline_id INT,
    aircraft_id INT,
    route_id INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);
CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY,
    flight_id INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    schedule_id INT,
    booking_date DATE,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id)
);
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    booking_id INT,
    seat_number VARCHAR(10),
    class VARCHAR(50),
    price DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    amount DECIMAL(10, 2),
    method VARCHAR(50),
    payment_date DATE,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50),
    airline_id INT,
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);
CREATE TABLE Staff_Assignments (
    assignment_id INT PRIMARY KEY,
    staff_id INT,
    flight_id INT,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
CREATE TABLE Luggage (
    luggage_id INT PRIMARY KEY,
    booking_id INT,
    weight DECIMAL(5,2),
    tag_number VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
CREATE TABLE Boarding_Passes (
    pass_id INT PRIMARY KEY,
    booking_id INT,
    gate VARCHAR(10),
    boarding_time DATETIME,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    comments TEXT,
    rating INT,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
INSERT INTO Airlines VALUES (1, 'SkyJet Airlines', 'USA'), (2, 'EuroFly', 'Germany');

INSERT INTO Aircrafts VALUES 
(1, 'Boeing 737', 180, 1),
(2, 'Airbus A320', 160, 2);

INSERT INTO Airports VALUES 
(1, 'JFK International', 'New York', 'USA'),
(2, 'Heathrow', 'London', 'UK'),
(3, 'Frankfurt Airport', 'Frankfurt', 'Germany');

INSERT INTO Routes VALUES 
(1, 1, 2),
(2, 2, 3);

INSERT INTO Flights VALUES 
(101, 1, 1, 1),
(102, 2, 2, 2);

INSERT INTO Schedules VALUES 
(1, 101, '2025-06-01 10:00:00', '2025-06-01 18:00:00', 'On Time'),
(2, 102, '2025-06-02 09:00:00', '2025-06-02 15:00:00', 'Delayed');

INSERT INTO Passengers VALUES 
(1, 'John Doe', 'john@example.com', '1234567890'),
(2, 'Alice Smith', 'alice@example.com', '0987654321');

INSERT INTO Bookings VALUES 
(1, 1, 1, '2025-05-01'),
(2, 2, 2, '2025-05-02');

INSERT INTO Tickets VALUES 
(1, 1, '12A', 'Economy', 350.00),
(2, 2, '14C', 'Business', 600.00);

INSERT INTO Payments VALUES 
(1, 1, 350.00, 'Credit Card', '2025-05-01'),
(2, 2, 600.00, 'PayPal', '2025-05-02');

INSERT INTO Staff VALUES 
(1, 'Emily Clark', 'Pilot', 1),
(2, 'Mark Lee', 'Flight Attendant', 2);

INSERT INTO Staff_Assignments VALUES 
(1, 1, 101),
(2, 2, 102);

INSERT INTO Luggage VALUES 
(1, 1, 23.5, 'TAG123'),
(2, 2, 18.0, 'TAG456');

INSERT INTO Boarding_Passes VALUES 
(1, 1, 'A12', '2025-06-01 09:15:00'),
(2, 2, 'B34', '2025-06-02 08:45:00');

INSERT INTO Feedback VALUES 
(1, 1, 101, 'Great flight!', 5),
(2, 2, 102, 'Could be better.', 3);

-- 1
SELECT f.flight_id, a.name AS airline, ap1.name AS source, ap2.name AS destination,
       s.departure_time, s.arrival_time, s.status
FROM Flights f
JOIN Airlines a ON f.airline_id = a.airline_id
JOIN Routes r ON f.route_id = r.route_id
JOIN Airports ap1 ON r.source_airport_id = ap1.airport_id
JOIN Airports ap2 ON r.destination_airport_id = ap2.airport_id
JOIN Schedules s ON f.flight_id = s.flight_id;

-- 2
SELECT p.name, p.email
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
JOIN Schedules s ON b.schedule_id = s.schedule_id
WHERE s.flight_id = 101;

-- 3
SELECT f.flight_id, SUM(t.price) AS total_revenue
FROM Flights f
JOIN Schedules s ON f.flight_id = s.flight_id
JOIN Bookings b ON s.schedule_id = b.schedule_id
JOIN Tickets t ON b.booking_id = t.booking_id
GROUP BY f.flight_id;

-- 4
SELECT s.name, s.role
FROM Staff s
JOIN Staff_Assignments sa ON s.staff_id = sa.staff_id
WHERE sa.flight_id = 101;

-- 5
SELECT f.flight_id, s.departure_time, s.arrival_time, s.status
FROM Flights f
JOIN Schedules s ON f.flight_id = s.flight_id
WHERE f.airline_id = 1;

-- 6
SELECT fb.comments, fb.rating
FROM Feedback fb
WHERE fb.flight_id = 101;

-- 7
SELECT b.booking_id, s.departure_time, t.seat_number, t.class, t.price
FROM Bookings b
JOIN Schedules s ON b.schedule_id = s.schedule_id
JOIN Tickets t ON b.booking_id = t.booking_id
WHERE b.passenger_id = 1;

-- 8
SELECT l.tag_number, l.weight
FROM Luggage l
WHERE l.booking_id = 1;

-- 9
SELECT bp.gate, bp.boarding_time
FROM Boarding_Passes bp
JOIN Bookings b ON bp.booking_id = b.booking_id
WHERE b.passenger_id = 1;

-- 10
SELECT flight_id, AVG(rating) AS avg_rating
FROM Feedback
GROUP BY flight_id;

-- 11
SELECT p.name, COUNT(b.booking_id) AS total_bookings
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
GROUP BY p.passenger_id
HAVING COUNT(b.booking_id) > 1;

-- 12
SELECT b.booking_id, p.method, p.amount, p.payment_date
FROM Bookings b
JOIN Payments p ON b.booking_id = p.booking_id;

-- 13
SELECT r.route_id, a1.name AS source, a2.name AS destination
FROM Routes r
JOIN Airports a1 ON r.source_airport_id = a1.airport_id
JOIN Airports a2 ON r.destination_airport_id = a2.airport_id;

-- 14
SELECT f.flight_id, s.departure_time
FROM Flights f
JOIN Schedules s ON f.flight_id = s.flight_id
WHERE s.departure_time BETWEEN '2025-06-01' AND '2025-06-03';

-- 15
SELECT name, role
FROM Staff
WHERE airline_id = 1;
















