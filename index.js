const express = require("express");
var cors = require('cors')
var http = require("http");

const dotenv = require('dotenv');
const config = dotenv.config({ path: '.env' }).parsed;

const app = express();
//middlewre
app.use(express.json());
app.use(cors())

const port = process.env.PORT || 9090;
var server = http.createServer(app);
var io = require("socket.io")(server);

var clients = {};

app.get('/', (req, res) => {
    res.send("<h1>server socket io is running ..</h1>");
});

const isValidJwt = (header) => {
    var token = "";

    try {
        console.log(header);
        token = header.split(' ')[1];
        console.log("token: " + token);
    } catch (e) {
        return false;
    }

    if (token === config.TOKEN) {
        return true;
    } else {
        console.log('disconnect');
        return false;
    }
};

// io.of('/test');
io.use((socket, next) => {
    const header = socket.handshake.headers['authorization'];

    if (isValidJwt(header)) {
        return next();
    }

    return next(new Error('authentication error'));
});

io.on("connection", (socket) => {
    console.log("connetetd");
    console.log(socket.id, "has joined");

    socket.on("signin", (id) => {
        console.log('id: ' + id);
        clients[id] = socket;
        // console.log(clients);
    });

    socket.on("message", (msg) => {
        console.log(msg);
        let targetId = msg.targetId;
        if (clients[targetId]) clients[targetId].emit("message", msg);
    });

    socket.on("entrance", (msg) => {
        console.log(msg);
        try {
            clients["flutter-socket-io-entrance"].emit("message", msg)
        }
        catch (e) {
            console.log(e);
        }
    });

    socket.on("exit", (msg) => {
        console.log(msg);
        try {
            clients["flutter-socket-io-exit"].emit("message", msg)
        }
        catch (e) {
            console.log(e);
        }
    });

    console.log("");
});

server.listen(port, "0.0.0.0", () => {
    console.log("server started");
});


// npm run dev
// "dev": "nodemon index"


// "start": "node server.js"