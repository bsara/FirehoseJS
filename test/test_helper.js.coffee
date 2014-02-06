window.nextTestAgent = (callback) ->
  window.testAgentNumber ||= 1
  nextAgent = Firehose.Agent.agentWithEmailAndPassword( "agent#{window.testAgentNumber++}@example.com", "pw")
  nextAgent.login().then ->
    callback(nextAgent)
    
    
window.realTestAgent = (callback) ->
  realAgent = Firehose.Agent.agentWithEmailAndPassword( "real@example.com", "pw")
  realAgent.login().then ->
    callback(realAgent)
  
    
window.firehoseTest = (title, assertionCount, callback) ->
  asyncTest title, assertionCount, ->
    window.nextTestAgent (nextAgent) ->
      callback(nextAgent)
