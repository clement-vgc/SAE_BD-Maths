DROP TABLE Vol CASCADE CONSTRAINTS;
DROP TABLE Aeroport CASCADE CONSTRAINTS;

CREATE TABLE Aeroport (
    id_aero  NUMBER PRIMARY KEY,
    nom_aero VARCHAR(100) NOT NULL UNIQUE,
    ville    VARCHAR(100),
    pays     VARCHAR(100)
);

CREATE TABLE Vol (
    compagnie       VARCHAR(100),
    num_vol         NUMBER,
    date_heure_dep  TIMESTAMP,
    date_heure_arr  TIMESTAMP,
    id_aero_dep     NUMBER,
    terminal_dep    VARCHAR(20),
    id_aero_arr     NUMBER,
    terminal_arr    VARCHAR(20),
    CONSTRAINT pk_vol PRIMARY KEY (compagnie, num_vol, date_heure_dep),
    CONSTRAINT fk_aero_dep FOREIGN KEY (id_aero_dep) REFERENCES Aeroport(id_aero),
    CONSTRAINT fk_aero_arr FOREIGN KEY (id_aero_arr) REFERENCES Aeroport(id_aero)
);