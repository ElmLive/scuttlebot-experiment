var WebSocket = require('ws')
var WebSocketServer = WebSocket.Server
var wss = new WebSocketServer({ port: 8080 })

var pull = require('pull-stream')
var ssbClient = require('ssb-client')

wss.on('connection', function connection (ws) {
  ssbClient(function (err, sbot) {
    if (err)
      throw err

    ws.on('message', function incoming (message) {
      console.log('received: %s', message)
      sbot.publish(JSON.parse(message), function (err, msg) {
        if (err) throw err

        console.log('stored: %s', msg)
      })
    })

    pull(
      sbot.createLogStream({ live: true }),
      pull.drain(function next (data) {
        if (ws.readyState == WebSocket.OPEN) {
          ws.send(JSON.stringify(data))
        } else {
          console.log('done: socket was closed')
          sbot.close()
        }
      }, function done () {
        console.log('done: stream ended')
        sbot.close()
      })
    )
  })
})
