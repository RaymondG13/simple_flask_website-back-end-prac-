from flask import Blueprint, jsonify, request
from app.models import Product

products_bp = Blueprint('products', __name__)

@products_bp.route('/', methods=['GET'])
def get_products():
    category = request.args.get('category')
    query = Product.query
    if category:
        query = query.filter_by(category=category)
    products = query.all()
    return jsonify([{
        'id': p.id,
        'name': p.name,
        'category': p.category,
        'price': float(p.price),
        'old_price': float(p.old_price) if p.old_price else None,
        'description': p.description,
        'image_url': p.image_url
    } for p in products]), 200

@products_bp.route('/<int:product_id>', methods=['GET'])
def get_product(product_id):
    p = Product.query.get_or_404(product_id)
    return jsonify({
        'id': p.id,
        'name': p.name,
        'category': p.category,
        'price': float(p.price),
        'old_price': float(p.old_price) if p.old_price else None,
        'description': p.description,
        'image_url': p.image_url
    }), 200