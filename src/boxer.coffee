fs = require 'fs'
path = require 'path'
nopt = require 'nopt'
mustache = require 'mustache'

app = ->
  proc = if process.argv[0] is 'node' then process.argv[1] else process.argv[0]
  path.basename proc

version = ->
  (require '../package.json').version

print = (text) ->
  baseTemplate = """
    {{placeholder}}
        {{appUpper}}

        {{text}}

        {{app}} v{{version}}

  """
  out = mustache.render baseTemplate,
    text: text
    app: app()
    appUpper: app().toUpperCase()
    version: version()

  console.log out

help = (commands, location) ->
  context =
    summaries: getCommandModule(name, location).summary() for name in commands

  template = """
    {{#summaries}}
    {{.}}
    {{/summaries}}
  """
  print mustache.render(template, context)

class BoxerModule
  constructor: (@name, {@description, @options, @action, @signature}) ->

  run: ->
    parameters = nopt @optionsNopt(), @aliasesNopt(), process.argv, 2
    @action parameters

  summary: ->
    "#{@name}   #{@description}\n"

  printDetails: ->
    template = """
        {{description}}

        OPTIONS

    {{#options}}
        {{name}}    {{description}}
    {{/options}}

    """
    context =
      app: app().toUpperCase()
      command: @name.toUpperCase()
      description: @description
      options: @options

    print mustache.render(template, context)

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