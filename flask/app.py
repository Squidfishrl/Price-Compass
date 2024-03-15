import config

from flask import render_template
from dotenv import load_dotenv

app = config.connex_app
app.add_api(config.basedir / "./swagger.yml")

@app.route("/")
def home():
    return render_template("./test.html")

if __name__ == "__main__":
    load_dotenv()
    app.run(host="0.0.0.0", port=8000)
