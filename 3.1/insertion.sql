-- insertion des Aéroports
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (1, 'Charles de Gaulle', 'Paris', 'FR');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (2, 'Antonio Carlos Jobim', 'Rio', 'BR');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (3, 'Heathrow', 'Londres', 'GB');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (4, 'JFK', 'New York', 'US');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (5, 'Narita', 'Tokyo', 'JP');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (6, 'Kingsford Smith', 'Sydney', 'AU');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (7, 'Auckland Airport', 'Auckland', 'NZ');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (8, 'Brandenburg', 'Berlin', 'DE');
INSERT INTO Aeroport (id_aero, nom_aero, ville, pays) VALUES (9, 'Fiumicino', 'Rome', 'IT');

-- test requête a : Vol direct depuis Paris (Paris -> Rio)
INSERT INTO Vol
VALUES ('Air France', 442, TO_TIMESTAMP('2023-07-10 23:30', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-11 05:30', 'YYYY-MM-DD HH24:MI'), 1, '2E', 2, '1');

INSERT INTO Vol
VALUES ('British Airways', 101, TO_TIMESTAMP('2023-07-10 10:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-10 11:30', 'YYYY-MM-DD HH24:MI'), 1, '2A', 3, '5');

-- test requête b : 1ère correspondance (Londres -> New York)
INSERT INTO Vol
VALUES ('Virgin Atlantic', 202, TO_TIMESTAMP('2023-07-10 14:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-10 18:00', 'YYYY-MM-DD HH24:MI'), 3, '3', 4, '4');

-- test requête c : 2ème correspondance (New York -> Tokyo)
INSERT INTO Vol
VALUES ('JAL', 303, TO_TIMESTAMP('2023-07-10 21:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-11 15:00', 'YYYY-MM-DD HH24:MI'), 4, '1', 5, '2');

-- test requête d : 3ème correspondance pour valider la récursivité infinie (Tokyo -> Sydney)
INSERT INTO Vol
VALUES ('Qantas', 404, TO_TIMESTAMP('2023-07-11 18:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-12 05:00', 'YYYY-MM-DD HH24:MI'), 5, '2', 6, '1');

-- test requête d : 4ème correspondance pour valider la récursivité infinie (Sydney -> Auckland)
INSERT INTO Vol
VALUES ('Air New Zealand', 505, TO_TIMESTAMP('2023-07-12 09:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-12 14:00', 'YYYY-MM-DD HH24:MI'), 6, '1', 7, '1');

-- réseau déconnecté de Paris pour prouver que la requête d ne prend pas tout (Berlin -> Rome)
INSERT INTO Vol
VALUES ('Lufthansa', 606, TO_TIMESTAMP('2023-07-10 08:00', 'YYYY-MM-DD HH24:MI'), TO_TIMESTAMP('2023-07-10 10:00', 'YYYY-MM-DD HH24:MI'), 8, '1', 9, '3');

COMMIT;