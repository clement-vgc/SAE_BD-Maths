-- Insertion des Aéroports
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (1, 'Charles de Gaulle', 'Paris', 'FR');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (2, 'Antonio Carlos Jobim', 'Rio', 'BR');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (3, 'Heathrow', 'Londres', 'GB');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (4, 'JFK', 'New York', 'US');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (5, 'Narita', 'Tokyo', 'JP');

-- Vol Direct : Paris -> Rio 
INSERT INTO Vol
VALUES ('Air France', 442, TO_TIMESTAMP('2023-07-10 23:30', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-11 05:30', 'YYYY-MM-DD HH24:MI'), 1, '2E', 2, '1');

-- Trajet pour tester les correspondances : Paris -> Londres -> New York -> Tokyo
INSERT INTO Vol
VALUES ('British Airways', 101, TO_TIMESTAMP('2023-07-10 10:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-10 11:30', 'YYYY-MM-DD HH24:MI'), 1, '2A', 3, '5');

INSERT INTO Vol
VALUES ('Virgin Atlantic', 202, TO_TIMESTAMP('2023-07-10 14:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-10 18:00', 'YYYY-MM-DD HH24:MI'), 3, '3', 4, '4');

INSERT INTO Vol
VALUES ('JAL', 303, TO_TIMESTAMP('2023-07-10 21:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-11 15:00', 'YYYY-MM-DD HH24:MI'), 4, '1', 5, '2');

COMMIT;