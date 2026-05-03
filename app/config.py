import os
from datetime import timedelta

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', 'smartedge-secret-key-2026')
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'smartedge-jwt-secret-2026')
    SQLALCHEMY_DATABASE_URI = os.getenv(
        'DATABASE_URL',
        'mysql+pymysql://root:@localhost/smartedge'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False


JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=24)