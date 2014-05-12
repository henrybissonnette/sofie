module.exports =
  options:[{
    name: 'comments'
    alias: 'c'
    type: Boolean
    description: "Include sofie comments in built files."
    }]
  action: (parameters) ->
    @printDetails()

  description: "Builds routes from sophie.config file."