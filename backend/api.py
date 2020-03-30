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

    place_id = request.args["place_id"]

    location_info = populartimes.get_id(os.environ["GMAPS_PLACES_API_KEY"], place_id)

    if "current_popularity" in location_info:
        current_popularity = location_info["current_popularity"]
        return jsonify(current_popularity=current_popularity)

    day_of_week = datetime.strftime(datetime.now(), "%A")
    hour_of_day = int(datetime.strftime(datetime.now(), "%H"))

    expected_popularity = 0
    for day in location_info["populartimes"]:
        if day_of_week.lower() == day["name"].lower():
            expected_popularity = day["data"][hour_of_day]
            break

    return jsonify(expected_popularity=expected_popularity)


def add_amount_to_coords(lat: float, lon: float, amount: int):
    new_lat = lat + amount / 1000 / 111.11
    new_lon = lon + amount / 1000 / 111.11

    return new_lat, new_lon


@app.route("/area-popularity")
def get_area_popularity():
    lat = float(request.args["lat"])
    lon = float(request.args["lon"])

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
