from dataclasses import dataclass
import json

from flask import Response, jsonify, abort, request
from config import db
from models.product import Product, product_schema
from models.price import Price
from sqlalchemy import select

@dataclass
class ProductPrices:
    ean13: str
    brand: str|None
    name: str
    category: str|None
    imageUrl: str|None
    stores: dict[str, list[dict[str, float|str]]] 

def get_all():
    products = Product.query.all()
    product_infos = []

    for product in products:
        result = db.session.execute(select(Price.store_name, Price.price, Price.date)\
                .where(Price.product_EAN == product.EAN))

        stores = {}
        for res in result.all():
            store_names = res[0]
            if stores.get(store_names) is None:
                stores[store_names] = []

            stores[store_names].append({"price" : res[1], "date" : str(res[2])})

        product_info = ProductPrices(ean13=product.EAN, brand=product.brand,
            name=product.name, category=product.category,
            imageUrl=product.image_url, stores=stores)

        product_infos.append(product_info.__dict__)

    return Response(json.dumps(product_infos),  mimetype='application/json')

def get_by_EAN(EAN: str):
    product = Product.query.filter(Product.EAN == EAN).one_or_none()

    if product is None:
        abort(404, f"Product with EAN '{EAN}' not found.")

    result = db.session.execute(select(Price.store_name, Price.price, Price.date)\
                       .where(Price.product_EAN == product.EAN))

    stores = {}
    for res in result.all():
        store_names = res[0]
        if stores.get(store_names) is None:
            stores[store_names] = []

        stores[store_names].append({"price" : res[1], "date" : str(res[2])})

    product_info = ProductPrices(ean13=product.EAN, brand=product.brand,
                                 name=product.name, category=product.category,
                                 imageUrl=product.image_url, stores=stores)

    return jsonify(product_info)

def get_by_name(name: str):
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
