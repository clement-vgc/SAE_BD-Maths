from flask import Flask, jsonify, request
from flask_cors import CORS
import db

app = Flask(__name__)
CORS(app)

@app.route('/api/vols', methods=['GET'])
def get_vols():
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT compagnie, num_vol, id_aero_dep AS depart, id_aero_arr AS arrivee FROM Vol")
        
        colonnes = [col[0].lower() for col in cursor.description]
        vols = [dict(zip(colonnes, ligne)) for ligne in cursor.fetchall()]

        cursor.close()
        conn.close()
        return jsonify(vols), 200
        
    except Exception as e:
        print(f"Erreur GET : {e}")
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/vols', methods=['POST'])
def add_vol():
    nouveau_vol = request.get_json()
    
    if not nouveau_vol or "compagnie" not in nouveau_vol:
        return jsonify({"erreur": "Données invalides"}), 400
        
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        # SÉCURITÉ : Vérifier si le vol existe déjà
        cursor.execute("SELECT COUNT(*) FROM Vol WHERE compagnie = :1 AND num_vol = :2", 
                       (nouveau_vol['compagnie'], nouveau_vol['num_vol']))
        if cursor.fetchone()[0] > 0:
            return jsonify({"erreur": "Ce vol (Même compagnie et même numéro) existe déjà !"}), 400

        cursor.execute("""
            INSERT INTO Vol (compagnie, num_vol, date_heure_dep, id_aero_dep, id_aero_arr)
            VALUES (:1, :2, SYSTIMESTAMP, :3, :4)
        """, (nouveau_vol['compagnie'], nouveau_vol['num_vol'], nouveau_vol['depart'], nouveau_vol['arrivee']))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Vol ajouté avec succès", "vol": nouveau_vol}), 201
        
    except Exception as e:
        print(f"Erreur POST : {e}")
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/vols/<compagnie>/<int:num_vol>', methods=['DELETE'])
def delete_vol(compagnie, num_vol):
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            DELETE FROM Vol 
            WHERE compagnie = :1 AND num_vol = :2
        """, (compagnie, num_vol))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Vol supprimé"}), 200
        
    except Exception as e:
        print(f"Erreur DELETE : {e}")
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/vols/<compagnie>/<int:num_vol>', methods=['PUT'])
def update_vol(compagnie, num_vol):
    donnees = request.get_json()
    
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            UPDATE Vol 
            SET id_aero_dep = :1, id_aero_arr = :2
            WHERE compagnie = :3 AND num_vol = :4
        """, (donnees['depart'], donnees['arrivee'], compagnie, num_vol))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Vol modifié"}), 200
        
    except Exception as e:
        print(f"Erreur PUT : {e}")
        return jsonify({"erreur": str(e)}), 500
    

@app.route('/api/aeroports', methods=['GET'])
def get_aeroports():
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT id_aero, nom_aero, ville, pays FROM Aeroport")
        colonnes = [col[0].lower() for col in cursor.description]
        aeroports = [dict(zip(colonnes, ligne)) for ligne in cursor.fetchall()]

        cursor.close()
        conn.close()
        return jsonify(aeroports), 200
    except Exception as e:
        print(f"Erreur GET Aéroports : {e}")
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/aeroports', methods=['POST'])
def add_aeroport():
    data = request.get_json()
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("SELECT COUNT(*) FROM Aeroport WHERE id_aero = :1 OR nom_aero = :2", 
                       (data['id_aero'], data['nom_aero']))
        if cursor.fetchone()[0] > 0:
            return jsonify({"erreur": "Un aéroport avec cet ID ou ce nom existe déjà !"}), 400

        cursor.execute("""
            INSERT INTO Aeroport (id_aero, nom_aero, ville, pays)
            VALUES (:1, :2, :3, :4)
        """, (data['id_aero'], data['nom_aero'], data['ville'], data['pays']))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Aéroport ajouté"}), 201
    except Exception as e:
        print(f"Erreur POST Aéroports : {e}")
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/aeroports/<int:id_aero>', methods=['DELETE'])
def delete_aeroport(id_aero):
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("DELETE FROM Vol WHERE id_aero_dep = :1 OR id_aero_arr = :2", (id_aero, id_aero))
        
        cursor.execute("DELETE FROM Aeroport WHERE id_aero = :1", (id_aero,))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Aéroport et vols associés supprimés"}), 200
    except Exception as e:
        print(f"Erreur DELETE Aéroports : {e}")
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/aeroports/<int:id_aero>', methods=['PUT'])
def update_aeroport(id_aero):
    data = request.get_json()
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            UPDATE Aeroport 
            SET nom_aero = :1, ville = :2, pays = :3
            WHERE id_aero = :4
        """, (data['nom_aero'], data['ville'], data['pays'], id_aero))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Aéroport modifié avec succès"}), 200
    except Exception as e:
        print(f"Erreur PUT Aéroports : {e}")
        return jsonify({"erreur": str(e)}), 500
    


if __name__ == '__main__':
    app.run(debug=True, port=5000)