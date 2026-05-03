from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from app.models import db, CartItem, Product, Order, OrderItem

cart_bp = Blueprint('cart', __name__)

@cart_bp.route('/', methods=['GET'])
@jwt_required()
def get_cart():
    user_id = get_jwt_identity()
    items = CartItem.query.filter_by(user_id=user_id).all()
    result = []
    for item in items:
        p = Product.query.get(item.product_id)
        result.append({
            'cart_item_id': item.id,
            'product_id': p.id,
            'name': p.name,
            'price': float(p.price),
            'image_url': p.image_url,
            'quantity': item.quantity
        })
    return jsonify(result), 200

@cart_bp.route('/add', methods=['POST'])
@jwt_required()
def add_to_cart():
    user_id = get_jwt_identity()
    data = request.get_json()
    product_id = data.get('product_id')

    existing = CartItem.query.filter_by(user_id=user_id, product_id=product_id).first()
    if existing:
        existing.quantity += 1
    else:
        db.session.add(CartItem(user_id=user_id, product_id=product_id))
    db.session.commit()
    return jsonify({'message': 'Added to cart'}), 200

@cart_bp.route('/remove/<int:item_id>', methods=['DELETE'])
@jwt_required()
def remove_from_cart(item_id):
    item = CartItem.query.get_or_404(item_id)
    db.session.delete(item)
    db.session.commit()
    return jsonify({'message': 'Removed from cart'}), 200

@cart_bp.route('/clear', methods=['DELETE'])
@jwt_required()
def clear_cart():
    user_id = get_jwt_identity()
    CartItem.query.filter_by(user_id=user_id).delete()
    db.session.commit()
    return jsonify({'message': 'Cart cleared'}), 200

@cart_bp.route('/checkout', methods=['POST'])
@jwt_required()
def checkout():
    user_id = get_jwt_identity()
    items = CartItem.query.filter_by(user_id=user_id).all()

    if not items:
        return jsonify({'error': 'Your cart is empty'}), 400

    # Calculate total
    total = 0
    order_items = []
    for item in items:
        p = Product.query.get(item.product_id)
        total += float(p.price) * item.quantity
        order_items.append({
            'product_id': p.id,
            'quantity': item.quantity,
            'price_at_purchase': float(p.price)
        })

    delivery = 300.00
    total_with_delivery = total + delivery

    # Create order
    order = Order(
        user_id=user_id,
        total=total_with_delivery,
        delivery=delivery,
        status='pending'
    )
    db.session.add(order)
    db.session.flush()  # get order.id before commit

    # Save order items
    for oi in order_items:
        db.session.add(OrderItem(
            order_id=order.id,
            product_id=oi['product_id'],
            quantity=oi['quantity'],
            price_at_purchase=oi['price_at_purchase']
        ))

    # Clear cart
    CartItem.query.filter_by(user_id=user_id).delete()
    db.session.commit()

    return jsonify({
        'message': 'Order placed successfully',
        'order_id': order.id,
        'total': total_with_delivery,
        'status': 'pending'
    }), 201