class Firehose.Typer extends Firehose.Object


  # @nodoc
  @_firehoseType: "Typer"

  ###
  @property [Firehose.Visitor]
  ###
  visitor: null

  ###
  @property [Firehose.TyperKind]
  ###
  kind: null


  ###
  @param id [Number or String] The ID of the agent or visitor that the created typer represents.
  @param visitor [Firehose.Visitor] The visitor that contains the typer to be created.
  @param kind [Firehose.TyperKind] The type/kind of typer that the created typer represents.
  ###
  @createTyper: (id, visitor, kind) ->
    Firehose.Object._objectOfClassWithID Firehose.Typer,
      id      : id
      visitor : visitor


  getTyperRepresented: () ->
    if kind == Firehose.TyperKind.AGENT
      return Firehose.Agent.agentWithID @get('id')
    if kind == Firehose.TyperKind.VISITOR
      return @get 'visitor'
    return null