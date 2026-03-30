import sqlite3

conn = sqlite3.connect('local_vols.db')
cursor = conn.cursor()

cursor.execute('''
CREATE TABLE IF NOT EXISTS Vol (
    compagnie TEXT,
    num_vol INTEGER,
    id_aero_dep INTEGER,
    id_aero_arr INTEGER
)
''')

cursor.execute("INSERT INTO Vol VALUES ('Air France', 442, 1, 2)")
cursor.execute("INSERT INTO Vol VALUES ('British Airways', 101, 1, 3)")

conn.commit()
conn.close()