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
        
        # --- VERSION SQLITE ---
        vols = [dict(row) for row in cursor.fetchall()]
        
        # --- VERSION ORACLE ---
        # colonnes = [col[0].lower() for col in cursor.description]
        # vols = [dict(zip(colonnes, ligne)) for ligne in cursor.fetchall()]

        conn.close()
        return jsonify(vols), 200
        
    except Exception as e:
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/vols', methods=['POST'])
def add_vol():
    nouveau_vol = request.get_json()
    
    if not nouveau_vol or "compagnie" not in nouveau_vol:
        return jsonify({"erreur": "Données invalides"}), 400
        
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        # --- VERSION SQLITE ---
        cursor.execute("""
            INSERT INTO Vol (compagnie, num_vol, id_aero_dep, id_aero_arr)
            VALUES (?, ?, ?, ?)
        """, (nouveau_vol['compagnie'], nouveau_vol['num_vol'], nouveau_vol['depart'], nouveau_vol['arrivee']))

        # --- VERSION ORACLE ---
        # cursor.execute("""
        #     INSERT INTO Vol (compagnie, num_vol, id_aero_dep, id_aero_arr)
        #     VALUES (:1, :2, :3, :4)
        # """, (nouveau_vol['compagnie'], nouveau_vol['num_vol'], nouveau_vol['depart'], nouveau_vol['arrivee']))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Vol ajouté avec succès", "vol": nouveau_vol}), 201
        
    except Exception as e:
        return jsonify({"erreur": str(e)}), 500

@app.route('/api/vols/<compagnie>/<int:num_vol>', methods=['DELETE'])
def delete_vol(compagnie, num_vol):
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            DELETE FROM Vol 
            WHERE compagnie = ? AND num_vol = ?
        """, (compagnie, num_vol))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Vol supprimé"}), 200
        
    except Exception as e:
        return jsonify({"erreur": str(e)}), 500


@app.route('/api/vols/<compagnie>/<int:num_vol>', methods=['PUT'])
def update_vol(compagnie, num_vol):
    donnees = request.get_json()
    
    try:
        conn = db.get_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            UPDATE Vol 
            SET id_aero_dep = ?, id_aero_arr = ?
            WHERE compagnie = ? AND num_vol = ?
        """, (donnees['depart'], donnees['arrivee'], compagnie, num_vol))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"message": "Vol modifié"}), 200
        
    except Exception as e:
        return jsonify({"erreur": str(e)}), 500
        

if __name__ == '__main__':
    app.run(debug=True, port=5000)