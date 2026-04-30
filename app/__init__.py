from flask import Flask, send_from_directory
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from app.models import db
from app.config import Config
import os

def create_app():
    app = Flask(__name__,
                static_folder='../static',
                template_folder='..')

    app.config.from_object(Config)

    db.init_app(app)
    JWTManager(app)
    CORS(app)

    from app.routes.auth import auth_bp
    from app.routes.products import products_bp
    from app.routes.cart import cart_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(products_bp, url_prefix='/api/products')
    app.register_blueprint(cart_bp, url_prefix='/api/cart')

    # Serve HTML files
    @app.route('/')
    def home():
        return send_from_directory('..', 'hompage.html')

    @app.route('/<path:filename>')
    def serve_file(filename):
        return send_from_directory('..', filename)

    return app