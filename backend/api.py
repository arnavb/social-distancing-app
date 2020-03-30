import os
from datetime import datetime
from math import cos, pi

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


def add_amount_to_coords(lat: float, lon: float, amount: int):
    new_lat = lat + amount / 1000 / 111.11
    new_lon = lon + amount / 1000 / 111.11

    return new_lat, new_lon


@app.route("/area-popularity")
def get_popularity_in_area():
    lat = float(request.args["lat"])
    lon = float(request.args["lon"])

    api_key = os.environ["GMAPS_PLACES_API_KEY"]
    bottom_left = add_amount_to_coords(lat, lon, -500)
    top_right = add_amount_to_coords(lat, lon, 500)

    locations = populartimes.get(
        os.environ["GMAPS_PLACES_API_KEY"], ["restant"], bottom_left, top_right,
    )

    result = []
    for location in locations:
        current_location = {"name": location["name"]}
        if "current_popularity" in location:
            current_location["current_popularity"] = location["current_popularity"]
        else:
            day_of_week = datetime.strftime(datetime.now(), "%A")
            hour_of_day = int(datetime.strftime(datetime.now(), "%H"))

            for day in location["populartimes"]:
                if day_of_week.lower() == day["name"].lower():
                    current_location["expected_popularity"] = day["data"][hour_of_day]
                    break

        result.append(current_location)

    return jsonify(result)


if __name__ == "__main__":
    app.run()
