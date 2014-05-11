fs = require 'fs'
path = require 'path'

nopt = require 'nopt'

sofie = require './module'

knownOpts = {}
# options
knownOpts[opt] = Boolean for opt in [
  'comments'
]
# parameters
knownOpts[opt] = String for opt in ['init']
# list parameters
knownOpts[opt] = [String, Array] for opt in []

optAliases =
  c: '--comments'
  i: '--init'

options = nopt knownOpts, optAliases, process.argv, 2
positionalArgs = options.argv.remain
delete options.argv

# default values
options.comments ?= on

# options.ignoreMissing = options['ignore-missing']

if options.help
  $0 = if process.argv[0] is 'node' then process.argv[1] else process.argv[0]
  $0 = path.basename $0
  console.log "
  Usage: #{$0} OPT* path/to/entry-file.ext OPT*

  -a, --alias ALIAS:TO      replace requires of file identified by ALIAS with TO
  -h, --handler EXT:MODULE  handle files with extension EXT with module MODULE
  -m, --minify              minify output
  -o, --output FILE         output to FILE instead of stdout
  -r, --root DIR            unqualified requires are relative to DIR; default: cwd
  -s, --source-map FILE     output a source map to FILE
  -v, --verbose             verbose output sent to stderr
  -w, --watch               watch input files/dependencies for changes and rebuild bundle
  -x, --export NAME         export the given entry module as NAME
  --deps                    do not bundle; just list the files that would be bundled
  --help                    display this help message and exit
  --ignore-missing          continue without error when dependency resolution fails
  --inline-source-map       include the source map as a data URI in the generated bundle
  --inline-sources          include source content in generated source maps; default: on
  --node                    include process object; emulate node environment; default: on
  --version                 display the version number and exit
"
  process.exit 0

if options.version
  console.log (require '../package.json').version
  process.exit 0

unless positionalArgs.length is 1
  console.error 'wrong number of entry points given; expected 1'
  process.exit 1