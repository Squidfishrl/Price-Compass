import barcodenumber
import os
import requests

from config import serializer, db

class Product(db.Model):
    __tablename__ = "product"
    EAN = db.Column(db.String(13), primary_key=True, nullable=False)
    name = db.Column(db.String(128), unique=True, nullable=False)
    brand = db.Column(db.String(128))
    category = db.Column(db.String(128))
    image_url = db.Column(db.String(1024))
    size = db.Column(db.String(32))

    @classmethod
    def create(cls, EAN):
        self = cls()

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
        if response == [] or response.get("product") is None:
            raise  LookupError(f"API doesn't know about product with EAN '{EAN}'")

        self.name = response.get("product").get("title")
        self.brand = response.get("product").get("brand")
        categories = response.get("product").get("category")
        # we only care about main category
        if len(categories) == 0:
            self.category = None
        else:
            self.category

        image_urls = response.get("product").get("images")
        if len(image_urls) == 0:
            self.image_url = None
        else:
            self.image_url = image_urls[0]

        attributes = response.get("product").get("attributes")
        if type(attributes) == list:
            self.size = None
        else:
            self.size = attributes.get("size")

        return self 
    
class ProductSchema(serializer.SQLAlchemyAutoSchema):
    class Meta:
        model = Product
        load_instance = True
        sqla_session = db.session

product_schema = ProductSchema()
products_schema = ProductSchema(many=True)
