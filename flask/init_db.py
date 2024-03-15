import sqlite3
from config import app, db

def main():
    # create db if it doesn't exist
    app.app_context().push()
    db.create_all()

    conn = sqlite3.connect("products.db")

    try:
        conn.execute("DROP TABLE product")
        conn.execute("DROP TABLE store")
        conn.execute("DROP TABLE price")
    except:
        pass

    createProductTable(conn)
    createStoreTable(conn)
    createPriceTable(conn)


def createProductTable(conn):
    product_table_cmd = """
    CREATE TABLE product (
        EAN CHAR(13) PRIMARY KEY NOT NULL,
        name VARCHAR UNIQUE NOT NULL,
        brand VARCHAR,
        category VARCHAR,
        image_url VARCHAR,
        size VARCHAR,
        CHECK(LENGTH(EAN) == 13)
    );
    """
    conn.execute(product_table_cmd)

def createStoreTable(conn):
    store_table_cmd = """
    CREATE TABLE store (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR UNIQUE NOT NULL,
        location VARCHAR
    );
    """
    conn.execute(store_table_cmd)

def createPriceTable(conn):
    price_table_cmd = """
    CREATE TABLE price (
        product_EAN CHAR(13) NOT NULL,
        store_name VARCHAR NOT NULL,
        price REAL NOT NULL,
        date DATETIME NOT NULL,
        PRIMARY KEY(product_EAN, store_name, date),
        FOREIGN KEY (product_EAN)
            REFERENCES product (product_EAN),
        FOREIGN KEY (store_name)
            REFERENCES store (storeName)
    );
    """
    conn.execute(price_table_cmd)

if __name__ == "__main__":
    main()
