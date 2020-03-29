import os
from datetime import datetime

import populartimes
import requests
from dotenv import load_dotenv
from flask import Flask, jsonify, request
from requests import Response

# Load environment variables
load_dotenv()

app = Flask(__name__)


@app.route("/current-popularity")
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


# @app.route("/currentPopularity")
# def current_popularity_apify():
#     apify_api_key = os.environ["APIFY_API_KEY"]
#     request_body = {
#         "lat": "40.5300041",
#         "lng": "-74.378022",
#         "includeHistogram": True,
#         "includeReviews": False,
#         "includeImages": False,
#         "includeOpeningHours": False,
#         "includePeopleAlsoSearch": False,
#     }
#     response: Response = requests.post(
#         "https://api.apify.com/v2/acts/drobnikj~crawler-google-places/runs",
#         params=dict(token=apify_api_key),
#         data=request_body,
#     )
#     response.raise_for_status()
#
#     return jsonify(response.json())


@app.route("/nearby-locations")
def get_nearby_locations():
    lat = request.args.get("lat")
    lon = request.args.get("lon")

    client_id = os.environ["FOURSQUARE_CLIENT_ID"]
    client_secret = os.environ["FOURSQUARE_CLIENT_SECRET"]

    request_params = {
        "client_id": client_id,
        "client_secret": client_secret,
        "ll": f"{lat},{lon}",
        "radius": "1000",
        "v": datetime.today().strftime("%Y%m%d"),
    }
    response: Response = requests.get(
        "https://api.foursquare.com/v2/venues/search", params=request_params
    )

    response.raise_for_status()
    response_venues = response.json()["response"]["venues"]
    result = []

    for venue in response_venues:
        name = venue["name"]
        address = " ".join(venue["location"]["formattedAddress"])
        result.append({"name": name, "address": address})

    return jsonify(response.json())


if __name__ == "__main__":
    app.run()
