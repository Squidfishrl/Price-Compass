from datetime import datetime
from flask import jsonify, abort, request
from config import db
from models.price import Price, price_schema, prices_schema
from models.store import Store
from models.product import Product 
from endpoints.stores import add_store


def get_all():
    prices = Price.query.all()
    
    return jsonify(prices_schema.dump(prices))

def add_price():
    prices_info = request.get_json()
    price_entries = []

    for price_info in prices_info:
        price_entry = Price()

        product = Product.query.filter(price_info["product_EAN"] == Product.EAN)\
                               .one_or_none()
        if product is None:  # invalid EAN, ignore
            continue

        if price_info["price"] <= 0:  # ignore invalid prices
            continue

        store = Store.query.filter(price_info["store_name"] == Store.name)\
                           .one_or_none()
        if store is None:  # create store record if it doesn't exist
            add_store(price_info["store_name"])

        price_entry.product_EAN = price_info["product_EAN"]
        price_entry.price = price_info["price"]
        price_entry.store_name = price_info["store_name"]
        price_entry.date = datetime.now()

        db.session.add(price_entry)
        price_entries.append(price_entry)
    
    if price_entries == []:  # all data was invalid
        abort(400, "All products have invalid data")

    db.session.commit()
    return (price_schema.jsonify(price_entries), 201)
