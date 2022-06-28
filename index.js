const express = require("express");
var cors = require('cors')
var http = require("http");

const dotenv = require('dotenv');
const config = dotenv.config({ path: '.env' }).parsed;

const app = express();
//middlewre
app.use(express.json());
app.use(cors())

const portNumber = 9090;
const port = process.env.PORT || portNumber;
var server = http.createServer(app);
var io = require("socket.io")(server);

// if (true) {
//     const ngrok = require('ngrok');
//     (async function () {
//         const url = await ngrok.connect({
//             region: 'us',
//             subdomain: "socketio-service",
//             proto: 'http',
//             addr: portNumber,
//             authtoken: '1Z4FuXChSDd2OAdFcDxTS7h8aeQ_4LVDV8ErSMjeg6aphr1tA',
//             configPath: 'ngrok.yml',
//             onStatusChange: status => { console.log("status: " + status); }, // 'closed' - connection is lost, 'connected' - reconnected
//             onLogEvent: data => { console.log("data: " + data); }, // returns stdout messages from ngrok process
//         });

//         console.log(url);
//     })();
// }


var clients = {};

app.get('/', (req, res) => {
    res.send("<h1>server socket io is running ..</h1>");
});

const isValidJwt = (auth) => {
    /*
        wsl $ uuidgen -x
    */
    if (auth === config.TOKEN) {
        return true;
    } else {
        console.log('disconnect');
        return false;
    }
};

// io.use((socket, next) => {
//     const auth = socket.handshake.headers['authorization'];
//     console.log(socket.handshake.headers);

//     if (isValidJwt(auth)) {
//         return next();
//     }
//     return next(new Error('authentication error'));
// });

io.on("connection", (socket) => {
    console.log("connetetd");
    console.log(socket.id, "has joined");
    // console.log(socket.handshake.headers);

    socket.on("signin", (id) => {
        console.log('id: ' + id);
        clients[id] = socket;
        // console.log(clients);
    });

    socket.on("msg", (msg) => {
        console.log(msg);
        socket.emit("event", msg);
    });

    socket.on('join_room', room => {
        console.log("join_room: " + room);
        socket.join(room);
    });

    socket.on('will-message', msg => {
        console.log("will-message: " + msg);
    });

    socket.on('sent-message', item => {
        console.log(item);
        io.sockets.emit(item.room, item.topic)
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
// "start": "node index.js"

/*
pm2 start index.js -n "Hello Wold PM2"
pm2 start  index.js -i 2 // หมายถึง ทำเป็น cluster 2 ตัว
pm2 start index.js -i max // หมายถึงทำเป็น cluster มากที่สุดเท่าที่ cpu รองรับ

pm2 list

pm2 start index -i 2 // run program ใน mode cluster จำนวน 2 instance
pm2 scale index 4 // หมายถึงปรับจาก 2 เป็น 4

pm2 stop index // หยุดโปรแกรมตามชื่อที่กำหนด
pm2 stop 0 //หยุดโปรแกรมตาม id ที่กำหนด
pm2 stop all //หยุดโปรแกรมทั้งหมด

pm2 delete index //ลบโปรแกรมตามชื่อที่กำหนด
pm2 delete 0 //ลบโปรแกรมตาม id ที่กำหนด
pm2 delete all //ลบโปรแกรมทั้งหมด

pm2 restart index //restart โปรแกรมตามชื่อที่กำหนด
pm2 restart 0 //restart โปรแกรมตาม id ที่กำหนด
pm2 restart all //restart โปรแกรมทั้งหมด

pm2 reload index //reload โปรแกรมตามชื่อที่กำหนด
pm2 reload 0 //reload โปรแกรมตาม id ที่กำหนด
pm2 reload all //reload โปรแกรมทั้งหมด

pm2 info index // แสดง information ของ program ตามชื่อที่กำหนด
pm2 info 0 // แสดง information ของ program ตาม id ที่กำหนด

pm2 flush

pm2 startup // หมายถึงเมื่อมีการ start server ให้ program เรา start ด้วย
pm2 save // หมายถึงให้ pm2 เก็บข้อมูลทั้งหมดเพื่อใช้ตอน start

pm2 monit
*/
