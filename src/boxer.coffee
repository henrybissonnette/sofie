fs = require 'fs'
path = require 'path'
nopt = require 'nopt'

app = ->
  proc = if process.argv[0] is 'node' then process.argv[1] else process.argv[0]
  path.basename proc

version = ->
  (require '../package.json').version

print = (text) ->
  console.log """
            
    #{app().toUpperCase()}

    #{text}

    #{app()} v#{version()}

  """

help = (commands, location) ->
  out = ''
  for name in commands
    out += "  #{getCommandModule(name, location).summary()} \n"
  print out

class BoxerModule
  constructor: (@name, {@description, @options, @action, @signature}) ->

  run: ->
    parameters = nopt @optionsNopt(), @aliasesNopt(), process.argv, 2
    @action parameters

  summary: ->
    "#{@name}   #{@description}\n"

  printDetails: ->
    optionDescriptions = ''
    for option in @options
      optionDescriptions += "  #{option.name}   #{option.description}\n"

    print """
        COMMAND

          #{@name.toUpperCase()} -- #{@description}

        OPTIONS

        #{optionDescriptions}

    """

  optionsNopt: ->
    o = {}
    o[option.name] = option.type for option in @options
    o

  aliasesNopt: ->
    a = {}
    a[option.alias] = "--#{option.name}" for option in @options
    a

getCommandModule = (name, location) ->
  config = require path.join(__dirname, location.split('/')... , name)
  new BoxerModule name, config

module.exports = boxer = ({commands: commandNames, location}) ->
  location ?= './'

  command = nopt({}, {}, process.argv).argv.remain.shift()

  unless command and command in commandNames
    help commandNames, location
    process.exit 0

  module = getCommandModule command, location

  module.run()