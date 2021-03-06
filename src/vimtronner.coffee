program = require 'commander'
fs = require 'fs'
Server = require './server'
Client = require './client'
screen = require './client/screen'

exports = module.exports = (argv) ->
  program
    .version(JSON.parse(fs.readFileSync(__dirname + '/../package.json', 'utf8')).version)
    .option('-S, --server', 'launches in server only mode')
    .option('-C, --client', 'launches in client only mode')
    .option('-A, --address <address>', 'the address to connect the client')
    .option('-P, --port <port>', 'the port to launch the server or connect the client', 8766)
    .option('-G, --game <game>', 'the name of the game the client wants to join')
    .option('-N, --number <number of players>', 'the number of players required to play (applies to new game only)')
    .option('-W, --width <size>', 'the grid width', screen.columns)
    .option('-H, --height <size>', 'the grid height', screen.rows - 2)
    .option('-L, --list', 'list active games on the server')
    .parse(argv)

  try
    unless program.client?
      server = new Server
      server.listen(program.port)

    unless program.server?
      address = if program.client
        program.address ? 'vimtronner.herokuapp.com'
      else
        '127.0.0.1'

      port = if address == 'vimtronner.herokuapp.com'
        80
      else
        program.port

      client = new Client(address, port)
      if program.list
        client.listGames()
      else
        number = parseInt(program.number, 10)
        width = parseInt(program.width, 10)
        height = parseInt(program.height, 10)
        client.join({
          name: program.game
          numberOfPlayers: number
          width: width
          height: height
        })
  catch e
    console.log e.message
    process.exit 1
