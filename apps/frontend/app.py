import os
import requests
from flask import Flask, jsonify, render_template_string

app = Flask(__name__)

ORDERS_URL = os.getenv("ORDERS_URL", "http://orders-service:5001")

HTML = """
<!DOCTYPE html>
<html>
<head>
    <title>Zero Trust Shop</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 40px auto; padding: 0 20px; background: #f5f5f5; }
        h1 { color: #333; }
        .card { background: white; padding: 20px; margin: 10px 0; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .status { padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .healthy { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        button { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        button:hover { background: #0056b3; }
        input { padding: 8px; margin: 5px; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
    <h1>Zero Trust Shop</h1>

    <div class="card">
        <h2>Service Status</h2>
        <p>Frontend: <span class="status healthy">Healthy</span></p>
        <p>Orders: <span class="status {{ orders_status_class }}">{{ orders_status }}</span></p>
    </div>

    <div class="card">
        <h2>Place an Order</h2>
        <p>Product ID: <input type="number" id="product_id" value="1" min="1" max="4"></p>
        <p>Quantity: <input type="number" id="quantity" value="1" min="1"></p>
        <button onclick="placeOrder()">Place Order</button>
        <div id="order_result"></div>
    </div>

    <div class="card">
        <h2>Recent Orders</h2>
        {% for order in orders %}
        <p>Order #{{ order.id }} — {{ order.product_name }} x{{ order.quantity }} — ${{ order.total }} — <strong>{{ order.status }}</strong></p>
        {% else %}
        <p>No orders yet.</p>
        {% endfor %}
    </div>

    <script>
        async function placeOrder() {
            const product_id = parseInt(document.getElementById('product_id').value);
            const quantity = parseInt(document.getElementById('quantity').value);
            const res = await fetch('/place-order', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ product_id, quantity })
            });
            const data = await res.json();
            document.getElementById('order_result').innerHTML =
                res.ok ? '<p style="color:green">Order placed: ' + data.product_name + ' x' + data.quantity + '</p>'
                       : '<p style="color:red">Error: ' + data.error + '</p>';
            setTimeout(() => location.reload(), 1000);
        }
    </script>
</body>
</html>
"""

@app.route("/health")
def health():
    return jsonify({"status": "healthy", "service": "frontend"})

@app.route("/")
def index():
    try:
        response = requests.get(f"{ORDERS_URL}/orders", timeout=3)
        orders = response.json()
        orders_status = "Healthy"
        orders_status_class = "healthy"
    except:
        orders = []
        orders_status = "Unreachable"
        orders_status_class = "error"

    return render_template_string(HTML, orders=orders,
                                  orders_status=orders_status,
                                  orders_status_class=orders_status_class)

@app.route("/place-order", methods=["POST"])
def place_order():
    from flask import request
    data = request.get_json()
    try:
        response = requests.post(f"{ORDERS_URL}/orders", json=data, timeout=3)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Could not reach orders service: {str(e)}"}), 503

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)
