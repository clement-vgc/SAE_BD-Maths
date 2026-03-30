import oracledb

def get_connection():
    return oracledb.connect(
        user="riotte",
        password="riotte",
        dsn="ora12" 
    )