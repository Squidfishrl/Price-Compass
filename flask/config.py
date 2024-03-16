import os
import connexion
import pathlib
from dotenv import load_dotenv
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

from init_db import create_db

load_dotenv()

basedir = pathlib.Path(__file__).parent.resolve()
connex_app = connexion.App(__name__, specification_dir=basedir)

db_filename = os.getenv("DB_FILE_NAME")
if db_filename is None:
    db_filename = "products.db"  # default name

app = connex_app.app
app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{basedir / db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATION"] = False

db = SQLAlchemy(app)
serializer = Marshmallow(app)

db_file = pathlib.Path(basedir / db_filename)
if not db_file.is_file():
    create_db(db_filename, app, db)
