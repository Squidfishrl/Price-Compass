from flask import render_template, url_for
import connexion
import json

app = connexion.App(__name__, specification_dir="./")
app.add_api("./swagger.yml")

# this will be fetched from the backend
product1_json = '''{
    "brand": "STORCK",
    "name": "Смайл Гъмис",
    "category": "food",
    "imageURL": "",
    "stores": {
        "Lidl": [
            {
                "price": 2.08,
                "date": "15.03.2024"
            },
            {
                "price": 2.08,
                "date": "16.03.2024"
            }
        ],
        "Billa": [
            {            
                "price": 2.05,
                "date": "15.03.2024"
            },
            {            
                "price": 1.99,
                "date": "16.03.2024"
            }
        ]
    }
}'''
product1 = json.loads(product1_json);

@app.route("/")
def home():
    return render_template("./analytics.html", product=product1)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
