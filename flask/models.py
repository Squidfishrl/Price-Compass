from sqlalchemy import CheckConstraint
from config import serializer, db

class Product(db.Model):
    __tablename__ = "product"
    # __table_args__ = (
    #     CheckConstraint('len(EAN) == 13')
    # )
    EAN = db.Column(db.String(13), primary_key = True)
    name = db.Column(db.String(128), unique = True)
    brand = db.Column(db.String(128))
    category = db.Column(db.String(128))
    image_url = db.Column(db.String(1024))

    def __init__(self, EAN):
        # TODO: Use API
        self.EAN = str(EAN)
        if (len(self.EAN) != 13):
            raise ValueError("EAN is not 13 digits")

        self.name = "name: " + EAN
        self.brand = "brand"
        self.category = "category"
        self.image_url = "url"


class ProductSchema(serializer.SQLAlchemyAutoSchema):
    class Meta:
        model = Product
        load_instance = True
        sqla_session = db.session

product_schema = ProductSchema()
products_schema = ProductSchema(many=True)
