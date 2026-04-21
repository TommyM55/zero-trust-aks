from flask import Flask, jsonify

app = Flask(__name__)

products = [
    {"id": 1, "name": "Laptop", "price": 999.99, "stock": 10},
    {"id": 2, "name": "Mouse", "price": 29.99, "stock": 50},
    {"id": 3, "name": "Keyboard", "price": 79.99, "stock": 30},
    {"id": 4, "name": "Monitor", "price": 399.99, "stock": 15},
]

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "service": "products"})

@app.route("/products")
def get_products():
    return jsonify(products)

@app.route("/products/<int:product_id>")
def get_product(product_id):
    product = next((p for p in products if p["id"] == product_id), None)
    if product:
        return jsonify(product)
    return jsonify({"error": "Product not found"}), 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
