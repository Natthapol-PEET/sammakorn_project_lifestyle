/*
    Connect by firecamp V4
*/

const server = require('http').createServer((req, res) => {
    const headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'OPTIONS, POST, GET'
    };

    if (req.method === 'OPTIONS') {
        res.writeHead(204, headers);
        res.end();
        return;
    }

    if (['GET', 'POST'].indexOf(req.method) > -1) {
        res.writeHead(200, headers);
        res.end('Hello, Node Socket');
        return;
    }

    res.writeHead(405, headers);
    res.end(`${req.method} is not allowed for the request.`);
});

const io = require('socket.io')(server);

const isValidJwt = (header) => {
    const token = header.split(' ')[1];

    if (token === 'fg1pY_DwF8eZ8HyMAAAD') {
        return true;
    } else {
        console.log('disconnect');
        return false;
    }
};

// io.of('/test');
// io.use((socket, next) => {
//     const header = socket.handshake.headers['authorization'];
//     console.log(header);

//     if (isValidJwt(header)) {
//         return next();
//     }

//     return next(new Error('authentication error'));
// });

io.on('connection', (socket) => {
    socket.on('room', room => {
        console.log(room);
        socket.join(room);
    });

    socket.on('msg', (msg) => {
        console.log(msg);
    });
});

// setInterval(() => {
//     io.sockets.to('room1').emit('message', 'what is going on, party people?');
// }, 3000);

// setInterval(() => {
//     io.sockets.to('room2').emit('message', 'anyone in this room yet?');
// }, 3000);

server.listen(3000, () => {
    console.log('listening on *: http://127.0.0.1:3000/');
});

