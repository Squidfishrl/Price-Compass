import config

from flask import render_template
from dotenv import load_dotenv

from endpoints.products import get_by_EAN


app = config.connex_app
app.add_api(config.basedir / "./swagger.yml")

@app.route("/analytics/<ean>")
def analytics(ean):
    product = get_by_EAN(ean).get_json()
    print(product)
    return render_template("./analytics.html", product=product)

if __name__ == "__main__":
    load_dotenv()
    app.run(host="127.0.0.1", port=8000)
