import os
from datetime import datetime
from typing import Tuple

import populartimes
from dotenv import load_dotenv
from flask import Flask, jsonify, request

# Load environment variables
load_dotenv()

app = Flask(__name__)


@app.route("/current-popularity")
def get_current_popularity():
    """Get the current popularity, if it exists, for the location passed
    in the query string parameters"""

    place_id = request.args.get("place_id")

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


def add_amount_to_coords(lat: float, lng: float, amount: float) -> Tuple[float, float]:
    """Add a specified distance to the coordinates passed in as input

    :param lat: The latitude of the coordinate
    :param lng: The longitude of the coordinate
    :param amount: The distance, in meters to increase the coordinates by
    :returns: The coordinates with the distance added as a tuple
    """

    new_lat = lat + amount / 1000 / 111.11
    new_lng = lng + amount / 1000 / 111.11

    return new_lat, new_lng


@app.route("/area-popularity")
def get_area_popularity():
    """Get the popularity of all locations within a 500 meter square from the location
    passed in the query string parameters"""

    lat = request.args.get("lat", type=float)
    lng = request.args.get("lng", type=float)

    bottom_left = add_amount_to_coords(lat, lng, -500)
    top_right = add_amount_to_coords(lat, lng, 500)

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
