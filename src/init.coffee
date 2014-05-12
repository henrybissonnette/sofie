module.exports =
  signature: String
  options:[{
    name: 'comments'
    alias: 'c'
    type: Boolean
    description: "Include sofie comments in built files."
    }]
  action: (parameters) ->
    @printDetails()
  description: "Initializes a new sophie project."