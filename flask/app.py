from flask import render_template, url_for
import connexion

app = connexion.App(__name__, specification_dir="./")
app.add_api("./swagger.yml")

@app.route("/")
def home():
    return render_template("./analytics.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
