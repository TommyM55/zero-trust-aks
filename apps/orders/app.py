import os
import requests
from flask import Flask, jsonify, request

app = Flask(__name__)

PRODUCTS_URL = os.getenv("PRODUCTS_URL", "http://products-service:5000")

orders = []
order_counter = 1

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "service": "orders"})

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)

@app.route("/orders", methods=["POST"])
def create_order():
    global order_counter
    data = request.get_json()

    if not data or "product_id" not in data or "quantity" not in data:
        return jsonify({"error": "product_id and quantity are required"}), 400

    try:
        response = requests.get(f"{PRODUCTS_URL}/products/{data['product_id']}")
        if response.status_code == 404:
            return jsonify({"error": "Product not found"}), 404
        product = response.json()
    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Could not reach products service: {str(e)}"}), 503

    order = {
        "id": order_counter,
        "product_id": data["product_id"],
        "product_name": product["name"],
        "quantity": data["quantity"],
        "total": product["price"] * data["quantity"],
        "status": "confirmed"
    }

    orders.append(order)
    order_counter += 1

    return jsonify(order), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
