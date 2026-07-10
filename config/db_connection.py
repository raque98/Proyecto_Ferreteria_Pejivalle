"""
Modulo de conexión a Oracle Cloud.
Este es el ÚNICO lugar del proyecto donde se abre la conexión. Todo lo demás (DAOs) recibe la conexión ya lista para usar.
"""

import os
import oracledb
from dotenv import load_dotenv

# Carga las variables del archivo .env
load_dotenv()

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_DSN = os.getenv("DB_DSN")
WALLET_LOCATION = os.getenv("WALLET_LOCATION")
WALLET_PASSWORD = os.getenv("WALLET_PASSWORD")


def obtener_conexion():
    """
    Abre y retorna una conexión a la base de datos Oracle Cloud usando el wallet. Modo 'thin': no necesita Instant Client instalado.
    """
    conexion = oracledb.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        dsn=DB_DSN,
        config_dir=WALLET_LOCATION,
        wallet_location=WALLET_LOCATION,
        wallet_password=WALLET_PASSWORD,
    )
    return conexion