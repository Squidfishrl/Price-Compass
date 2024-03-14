from flask import jsonify, abort, request
from config import db
from models import Product, product_schema, products_schema

def read_products():
    products = Product.query.all()
    print(products)
    return jsonify(products_schema.dump(products))

def read_product(EAN):
    product = Product.query.filter(Product.EAN == EAN).one_or_none()

    if product is not None:
        return jsonify(product_schema.dump(product))
    else:
        abort(404, f"Product with EAN '{EAN}' not found")

def add_product():
    EAN = request.get_json()["EAN"]

    try:
        new_product = Product(EAN)
    except ValueError:
        abort(400, f"Invalid EAN '{EAN}'. Should be 13 digits long.")

    db.session.add(new_product)
    db.session.commit()
    return (product_schema.jsonify(new_product), 201)
