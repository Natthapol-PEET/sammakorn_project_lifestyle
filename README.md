# sammakorn_project_lifestyle

## How to create a self-signed PEM file
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem

-> mkcert -install
-> mkcert localhost 127.0.0.1 ::1


# creates image in current folder with tag nginx
docker build . -t nginx

# runs nginx image
docker run --rm -it  -p 80:80/tcp nginx:latest


