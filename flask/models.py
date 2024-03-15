import barcodenumber
import os
import requests

from sqlalchemy import CheckConstraint
from config import serializer, db

class Product(db.Model):
    __tablename__ = "product"
    EAN = db.Column(db.String(13), primary_key = True)
    name = db.Column(db.String(128), unique = True)
    brand = db.Column(db.String(128))
    category = db.Column(db.String(128))
    image_url = db.Column(db.String(1024))
    size = db.Column(db.String(32))

    def __init__(self, EAN):
        # TODO: Use API
        self.EAN = str(EAN)

        if not barcodenumber.check_code_ean13(EAN):
            raise ValueError(f"Invalid EAN {EAN}")

        api_key = str(os.getenv("API_KEY"))
        api_key_header = str(os.getenv("API_KEY_HEADER"))
        api_host = str(os.getenv("API_HOST"))
        api_host_header = str(os.getenv("API_HOST_HEADER"))
        url = str(os.getenv("URL"))

        query = {}
        query["query"] = EAN
        headers = {}
        headers[api_key_header] = api_key
        headers[api_host_header] = api_host

        response = requests.get(url, headers=headers, params=query).json()
        self.name = response.get("product").get("title")
        self.brand = response.get("product").get("brand")
        self.category = response.get("product").get("category")[0]
        self.image_url = response.get("product").get("images")[0]
        self.size = response.get("product").get("attributes").get("size")

class ProductSchema(serializer.SQLAlchemyAutoSchema):
    class Meta:
        model = Product
        load_instance = True
        sqla_session = db.session

product_schema = ProductSchema()
products_schema = ProductSchema(many=True)
