import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', 'smartedge-secret-key-2026')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'smartedge-jwt-secret-2026')
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:@localhost/smartedge'
    SQLALCHEMY_TRACK_MODIFICATIONS = False