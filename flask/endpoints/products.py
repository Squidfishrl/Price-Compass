from flask import jsonify, abort, request
from config import db
from models.product import Product, product_schema, products_schema
from models.price import Price
from sqlalchemy import select

class ProductPrices():
    pass

def get_all():
    products = Product.query.all()

    for product in products:
        result = db.session.execute(select(Price.store_name, Price.price, Price.date)\
                .where(Price.product_EAN == product.EAN))

        store_names = {}
        for res in result.all():
            if store_names.get(res[0]) is None:
                store


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

    existing_product = Product.query.filter(Product.EAN == EAN).one_or_none()
    if existing_product is not None:
        abort(409, f"Product with EAN 'f{EAN}'already exists")

    try:
        new_product = Product.create(EAN)
    except ValueError as err:
        abort(400, str(err))

    db.session.add(new_product)
    db.session.commit()
    return (product_schema.jsonify(new_product), 201)
