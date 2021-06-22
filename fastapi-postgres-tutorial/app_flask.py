from flask import Flask, request

app = Flask(__name__)


@app.route('/test', methods=['POST'])
def test():
    # return request.json
    print(request.get_json(force=True))
    return 200, 'OK'


if __name__ == '__main__':
   app.run(debug = True, host='0.0.0.0', port=5000)