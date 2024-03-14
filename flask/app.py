from flask import render_template, url_for
import connexion
import json

app = connexion.App(__name__, specification_dir="./")
app.add_api("./swagger.yml")

# this will be fetched from the backend
product1_json = '{\
    "name": "Смайл Гъмис",\
    "price": 2.08\
}'
product1 = json.loads(product1_json);

@app.route("/")
def home():
    return render_template("./analytics.html",
        name=product1["name"],
        price=product1["price"]
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
