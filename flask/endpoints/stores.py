from flask import jsonify, abort, request
from config import db
from models.store import Store, store_schema, stores_schema

def get_all():
    stores = Store.query.all()
    return jsonify(stores_schema.dump(stores))

def add_store(name=None):
    if name is None:
        name = request.get_json()["name"]

    existing_store = Store.query.filter(Store.name == name).one_or_none()
    if existing_store is not None:
        abort(409, f"Store with name '{name}' already exists")

    try:
        new_store = Store()
        new_store.name =  name
    except ValueError as err:
        abort(400, str(err))

    db.session.add(new_store)
    db.session.commit()
    return (store_schema.jsonify(new_store), 201)
