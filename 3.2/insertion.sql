INSERT INTO VOL_OR VALUES (
    'AF442', 'CDG', 1, 'GIG', 3, 
    equipageTabT(
        equipageT('Goscinny', 'Pilote'),
        equipageT('Uderzo', 'Commissaire')
    ),
    indiceList(
        indiceT('carbone', 3, 4),
        indiceT('securite', 4, 5),
        indiceT('prix', 4, 3)
    )
);
COMMIT;