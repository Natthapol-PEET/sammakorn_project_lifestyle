from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
    return "Hello World"


if __name__ == "__main__":
    app.run(debug=True, host='192.168.1.1', port=5000)
