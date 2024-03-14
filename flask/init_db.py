import sqlite3
from config import app, db

def main():
    # create db if it doesn't exist
    app.app_context().push()
    db.create_all()

    conn = sqlite3.connect("products.db")
    try:
        conn.execute("DROP TABLE product")
    except:
        pass

    columns = [
        "EAN CHAR(13) PRIMARY KEY",
        "name VARCHAR UNIQUE",
        "brand VARCHAR",
        "category VARCHAR",
        "image_url VARCHAR",
        "CHECK(LENGTH(EAN) == 13)"
    ]

    create_table_cmd = f"CREATE TABLE product ({','.join(columns)})"
    conn.execute(create_table_cmd)

if __name__ == "__main__":
    main()
