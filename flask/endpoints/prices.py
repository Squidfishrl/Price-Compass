from datetime import datetime
from flask import jsonify, abort, request
from config import db
from models.price import Price, price_schema, prices_schema
from models.store import Store


def get_all():
    prices = Price.query.all()
    
    return jsonify(prices_schema.dump(prices))

def add_price():
    price_info = request.get_json()
    price_entry = Price()
    store = Store.query.filter(price_info["store_name"] == Store.name)\
                                    .one_or_none()
    if store is None:
        abort(400, f"Store with name {price_info['store_name']} doesn't exist")

    price_entry.product_EAN = price_info["product_EAN"]
    price_entry.price = price_info["price"]
    price_entry.store_name = store.name
    price_entry.date = datetime.now()

    db.session.add(price_entry)
    db.session.commit()
    return (price_schema.jsonify(price_entry), 201)

