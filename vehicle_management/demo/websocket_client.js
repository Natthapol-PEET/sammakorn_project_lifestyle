// npm install ws

var WebSocket = require('ws')

const ws = new WebSocket('ws://192.168.0.100:8080/ws?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NTg5MDkyOTEsImlhdCI6MTYyNzM3MzI5MSwic3ViIjoicGVldCJ9.K3VpPzH0EcY8PaqhK1Z5MknD8ZB7SW3HDCDt4MqS4Kc', {
  perMessageDeflate: false
});

ws.on('open', function open() {
//   for(var i = 0; i < 10; i++) {
//     ws.send('something');
//   }
});

ws.on('message', function incoming(message) {
  console.log('received: %s', message);

  ws.close();
});