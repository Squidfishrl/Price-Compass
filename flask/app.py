import config
import json

from flask import render_template, url_for
from dotenv import load_dotenv

from endpoints.products import get_by_EAN


app = config.connex_app
app.add_api(config.basedir / "./swagger.yml")

# # this will be fetched from the backend
# product1_json = '''{
#     "brand": "STORCK",
#     "name": "Смайл Гъмис",
#     "category": "food",
#     "imageURL": "",
#     "stores": {
#         "Lidl": [
#             {
#                 "price": 2.08,
#                 "date": "15.03.2024"
#             },
#             {
#                 "price": 2.08,
#                 "date": "16.03.2024"
#             }
#         ],
#         "Billa": [
#             {            
#                 "price": 2.05,
#                 "date": "15.03.2024"
#             },
#             {            
#                 "price": 1.99,
#                 "date": "16.03.2024"
#             }
#         ]
#     }
# }'''
# product1 = json.loads(product1_json);

@app.route("/analytics/<ean>")
def analytics(ean):
    product = get_by_EAN(ean).get_json()
    print(product)
    return render_template("./analytics.html", product=product)

if __name__ == "__main__":
    load_dotenv()
    app.run(host="0.0.0.0", port=8000)
