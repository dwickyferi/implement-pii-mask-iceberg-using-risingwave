CREATE TABLE users_sensitive_data (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    phone VARCHAR(50),
    full_name VARCHAR(255),
    address TEXT,
    passport_number VARCHAR(50),
    national_id VARCHAR(50),
    credit_card_number VARCHAR(25),
    ssn VARCHAR(20),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users_sensitive_data (
    email, phone, full_name, address, passport_number,
    national_id, credit_card_number, ssn, date_of_birth
) VALUES
('alice.smith@example.com', '+1-202-555-0143', 'Alice Smith', '123 Apple St, New York, USA', 'A1234567', '987654321', '4111111111111111', '123-45-6789', '1985-06-15'),
('bob.johnson@example.com', '+44 20 7946 0958', 'Bob Johnson', '45 Baker St, London, UK', 'B7654321', '876543219', '5500000000000004', '987-65-4321', '1990-02-20'),
('charlie.lee@example.com', '+62 812-3456-7890', 'Charlie Lee', 'Jl. Merdeka No. 1, Jakarta, Indonesia', 'C2345678', '765432198', '340000000000009', '111-22-3333', '1988-11-11'),
('danielle.wang@example.com', '+86 10 8888 8888', 'Danielle Wang', '88 Nanjing Rd, Shanghai, China', 'D8765432', '654321987', '6011000000000004', '444-55-6666', '1995-07-07'),
('emmanuel.nguyen@example.com', '+33 1 44 55 66 77', 'Emmanuel Nguyen', '22 Rue de Lyon, Paris, France', 'E3456789', '543219876', '3530111333300000', '777-88-9999', '1982-01-01'),
('fatima.khan@example.com', '+971 50 123 4567', 'Fatima Khan', '101 Palm St, Dubai, UAE', 'F6543210', '432198765', '4111111111111111', '222-33-4444', '1993-03-12'),
('george.rodriguez@example.com', '+34 91 123 4567', 'George Rodriguez', '5 Gran Via, Madrid, Spain', 'G0987654', '321987654', '4000000000000002', '555-66-7777', '1987-08-22'),
('hannah.chen@example.com', '+81 3-1234-5678', 'Hannah Chen', '9 Shibuya, Tokyo, Japan', 'H4567890', '210987543', '6011000990139424', '999-00-1111', '1991-09-09'),
('ivan.petrov@example.com', '+7 495 123-45-67', 'Ivan Petrov', '15 Tverskaya St, Moscow, Russia', 'I5678901', '109876432', '378282246310005', '333-44-5555', '1980-04-04'),
('julia.almeida@example.com', '+55 11 91234-5678', 'Julia Almeida', 'Rua Augusta, São Paulo, Brazil', 'J6789012', '098765321', '6011000000000004', '666-77-8888', '1989-12-25');