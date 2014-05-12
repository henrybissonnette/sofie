{spawn} = require 'child_process'


task 'build', ->
  compileSrc()

compileSrc = ->
  launch 'coffee', ['-o', 'lib', '-c', 'src']
  launch 'npm', ['install', '.', '-g']

try
  which = require('which').sync
catch err
  if process.platform.match(/^win/)?
    console.log 'WARNING: the which module is required for windows\ntry: npm install which'
  which = null

launch = (cmd, options=[]) ->
  cmd = which(cmd) if which
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)