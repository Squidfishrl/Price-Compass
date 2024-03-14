from flask import render_template
import config
from models import Product

app = config.connex_app
app.add_api(config.basedir / "./swagger.yml")

@app.route("/")
def home():
    return render_template("./test.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
