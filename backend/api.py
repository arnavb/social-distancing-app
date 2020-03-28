import os

import populartimes
from dotenv import load_dotenv
from flask import Flask, jsonify

# Load environment variables
load_dotenv()

app = Flask(__name__)


@app.route("/")
def index():
    result = populartimes.get_id(
        os.environ["GMAPS_PLACES_API_KEY"], "ChIJIz36HAG3w4kRvB--Pl2EjIw"
    )
    return jsonify(result)


if __name__ == "__main__":
    app.run()
