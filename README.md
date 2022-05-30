# sammakorn_project_lifestyle

## How to create a self-signed PEM file
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem

