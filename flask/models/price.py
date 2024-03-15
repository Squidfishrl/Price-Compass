from config import serializer, db

class Price(db.Model):
    __tablename__ = "price"
    product_EAN = db.Column(db.String(13), db.ForeignKey('product.EAN'),
                           nullable=False, primary_key=True)
    store_name = db.Column(db.String(128), db.ForeignKey('store.name'), nullable=False,
                        primary_key=True)
    price = db.Column(db.Float, nullable=False)
    date = db.Column(db.DateTime, nullable = False, primary_key=True)

class PriceSchema(serializer.SQLAlchemyAutoSchema):
    class Meta:
        model = Price
        load_instance = True
        sqla_session = db.session

price_schema = PriceSchema()
prices_schema = PriceSchema(many=True)
