DROP TABLE VOL_OR CASCADE CONSTRAINTS;
DROP TYPE equipageTabT FORCE;
DROP TYPE equipageT FORCE;
DROP TYPE indiceList FORCE;
DROP TYPE indiceT FORCE;

-- types pour l'équipage (Nested Table)

-- création du type objet
CREATE OR REPLACE TYPE equipageT AS OBJECT (
    nom VARCHAR2(50),
    fonction VARCHAR2(50)
);
/

-- création du type Table
CREATE TYPE equipageTabT AS TABLE OF equipageT;
/

-- types pour les indices de qualité (Varray)

-- création de l'objet avec une méthode
CREATE OR REPLACE TYPE indiceT AS OBJECT (
    nom_indice VARCHAR2(50),
    valeur NUMBER,
    poids NUMBER,
    MEMBER FUNCTION get_impact RETURN NUMBER
);
/

-- implémentation du corps de l'objet pour la méthode
CREATE OR REPLACE TYPE BODY indiceT AS
    MEMBER FUNCTION get_impact RETURN NUMBER IS
    BEGIN
        RETURN valeur * poids;
    END;
END;
/

-- création du Varray de taille 3
CREATE TYPE indiceList AS VARRAY(3) OF indiceT;
/

-- création de la table avec stockage de la nested table
CREATE TABLE VOL_OR (
    NumVol VARCHAR2(20),
    AeroDep VARCHAR2(20),
    DateHeureDep NUMBER,
    AeroArr VARCHAR2(20),
    DateHeureArr NUMBER,
    Equipage equipageTabT,
    IndicesQualite indiceList
)
NESTED TABLE Equipage STORE AS Equipage_nt;