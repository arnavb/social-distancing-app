import os
import populartimes
from dotenv import load_dotenv
from flask import Flask, jsonify, request
import requests
# Load environment variables
load_dotenv()

app = Flask(__name__)


@app.route("/")
def get_current_popularity():
    """Get the current popularity, if it exists, for the location passed
    as a parameter"""

    json_data = populartimes.get_id(
        os.environ["GMAPS_PLACES_API_KEY"], "ChIJc_bAtSDIw4kRnfrNZxYHK_M"
    )
    if "current_popularity" in json_data:
        current_popularity = json_data["current_popularity"]
        return jsonify(current_popularity=current_popularity)

    return jsonify(error="NO_LIVE_DATA")
@app.route("/nearbyLocations")
def get_nearby_locations():
    lat = request.args.get("lat")
    lon = request.args.get("lon")
    
if __name__ == "__main__":
    app.run()
