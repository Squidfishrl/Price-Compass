from flask import jsonify, abort, request
from config import db
from models import Product, product_schema, products_schema

def get_all():
    products = Product.query.all()
    print(products)
    return jsonify(products_schema.dump(products))

def get_by_EAN(EAN):
    product = Product.query.filter(Product.EAN == EAN).one_or_none()

    if product is None:
        abort(404, f"Product with EAN '{EAN}' not found.")

    return jsonify(product_schema.dump(product))

def get_by_name(name):
    product = Product.query.filter(Product.name == name).one_or_none()

    if product is None:
        abort(404, f"Product with name '{name}' not found.")

    return jsonify(product_schema.dump(product))

def add_product():
    EAN = request.get_json()["EAN"]

    try:
        new_product = Product(EAN)
    except ValueError as err:
        abort(400, str(err))

    db.session.add(new_product)
    db.session.commit()
    return (product_schema.jsonify(new_product), 201)
