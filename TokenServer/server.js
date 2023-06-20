const { log } = require('console')

const app = require('express')()
const http = require('http').createServer(app)

const {RtcTokenBuilder, RtmTokenBuilder, RtcRole, RtmRole} = require('agora-access-token')
const agoraAppId = '53d1bde7af10469f858cfafdcb561a57';
const agoraAppCertificate = 'e0acdc5d4cec48f28ea17fb702ddeada';



const expirationTimeInSeconds = 3600
 
const currentTimestamp = Math.floor(Date.now() / 1000)
 
const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

app.get('/', (req, res) => {
    res.send("Node Server is running. Yay!!")
    log("server strated");
})

app.get('/token', (req, res) => {
  const token = RtcTokenBuilder.buildTokenWithUid(agoraAppId, agoraAppCertificate, req.query.channel_name,0, RtcRole.PUBLISHER, privilegeExpiredTs);

  res.json({ token: token });
});

//Socket Logic
const socketio = require('socket.io')(http)

socketio.on("connection", (userSocket) => {
  log(userSocket.id+" is connected "+" on "+new Date().toLocaleString());

    userSocket.on("send_message", (data) => {
       log(data);
       // userSocket.emit("receive_message", data)
       log(data.id);

        socketio.to(data.id).emit('receive_message', data.message);
    })

    userSocket.on("calling", (data) => {
       log(data);
       // userSocket.emit("receive_message", data)
       log(data.id);

        socketio.to(data.id).emit('incoming_call_event', data);
    })

    userSocket.on('disconnect', () => {

      console.log(userSocket.id+' is disconnected'+" on "+new Date().toLocaleString());
    });
})

http.listen(8081)