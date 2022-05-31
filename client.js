const io = require('socket.io-client');

// const socket = io('http://192.168.146.1:3000', {
const socket = io('http://127.0.0.1:8000/', {
    transportOptions: {
        polling: {
            extraHeaders: {
                'Authorization': 'Bearer fg1pY_DwF8eZ8HyMAAAD',
            },
        },
    },
});

socket.on('connect', () => {
    console.log('connected!');
    socket.emit('room', 'room1');           // join room 1
    socket.emit('room', 'room2');           // join room 2
});

socket.on('message', data => {
    console.log("message: " + data);
});