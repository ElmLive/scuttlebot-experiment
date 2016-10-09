var WebSocketServer = require('ws').Server
var wss = new WebSocketServer({ port: 8080 })
var pull = require('pull-stream')
var ssbClient = require('ssb-client')

wss.on('connection', function connection (ws) {
  ssbClient(function (err, sbot) {
    if (err)
      throw err

    pull(
      sbot.createLogStream(),
      pull.drain(function next (data) {
        ws.send(JSON.stringify(data))
      }, function done () {
        console.log('done')
        sbot.close()
      })
    )
  })
})
