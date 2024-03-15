from config import serializer, db

class Store(db.Model):
    __tablename__ = "store"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(128), unique=True, nullable=False)
    location = db.Column(db.String(256))

class StoreSchema(serializer.SQLAlchemyAutoSchema):
    class Meta:
        model = Store
        load_instance = True
        sqla_session = db.session

store_schema = StoreSchema()
stores_schema = StoreSchema(many=True)
