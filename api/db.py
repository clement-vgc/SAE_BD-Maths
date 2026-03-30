# --- VERSION SQLITE ---
import sqlite3

def get_connection():
    conn = sqlite3.connect('local_vols.db')
    conn.row_factory = sqlite3.Row
    return conn

# --- VERSION ORACLE ---
# import oracledb
#
# def get_connection():
#     return oracledb.connect(
#         user="ton_login",
#         password="ton_password",
#         dsn="ora12"
#     )