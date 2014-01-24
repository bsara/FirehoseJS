# ======== A Handy Little QUnit Reference ========
# http://api.qunitjs.com/

# Test methods:
#   module(name, {[setup][ ,teardown]})
#   test(name, callback)
#   expect(numberOfAssertions)
#   stop(increment)
#   start(decrement)
# Test assertions:
#   ok(value, [message])
#   equal(actual, expected, [message])
#   notEqual(actual, expected, [message])
#   deepEqual(actual, expected, [message])
#   notDeepEqual(actual, expected, [message])
#   strictEqual(actual, expected, [message])
#   notStrictEqual(actual, expected, [message])
#   throws(block, [expected], [message])

FirehoseJS.client.setEnvironment('test')

module "Agent"

asyncTest 'Sign Up', 8, ->
  agent = FirehoseJS.Agent.agentWithEmailAndPassword(Faker.Internet.email(), Faker.Name.firstName())
  agent.signUpWithFirstAndLastName( Faker.Name.firstName(), Faker.Name.lastName() )
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.id?
    ok agent.createdAt?
    equal agent.companies.length, 1
    ok agent.currentCompany?
    start()
  .fail ->
    start()
       
firehoseTest 'Log In With un/pw', 8, (agent) ->
  agent2 = FirehoseJS.Agent.agentWithEmailAndPassword( agent.email, "pw" )
  agent2.login()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent2.firstName?
    ok agent2.lastName?
    ok agent2.email?
    ok agent2.id?
    ok agent2.createdAt?
    equal agent2.companies.length, 1
    ok agent2.currentCompany?
    start()
  .fail ->
    start()
    
firehoseTest 'Log In With Access Token', 8, (agent) ->
  agent.email = null
  agent.login()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.id?
    ok agent.createdAt?
    equal agent.companies.length, 1
    ok agent.currentCompany?
    start()
  .fail ->
    start()
    
firehoseTest 'Fetch', 14, (agent) ->
  agent.fetch()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.id?
    ok agent.createdAt?
    equal agent.companies.length, 1
    company = agent.currentCompany
    ok company?
    ok company.id? 
    ok company.title?
    ok company.token?
    ok company.fetchAutomatically
    ok company.numberOfAccounts == 4
    ok company.createdAt?
    start()
  .fail ->
    start()
    
firehoseTest 'Update', 7, (agent) ->
  agent.firstName = "Heidi"
  agent.lastName  = "Kirk"
  agent.setNewPassword Faker.Lorem.words(1)
  agent.save()
  .done (data, textStatus) ->
    equal textStatus, "nocontent"
    agent.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      equal agent.firstName, "Heidi"
      equal agent.lastName, "Kirk"
      ok agent.email?
      ok agent.id?
      ok agent.createdAt?
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  agent.destroy()
  .done (data, textStatus) ->
    equal textStatus, "nocontent"
    start()
  .fail ->
    start()   
    
firehoseTest 'Status Code Handlers', 1, (agent) ->
  FirehoseJS.client.statusCodeHandlers =
    401: ->
      ok true
      start()
  FirehoseJS.client.APIAccessToken = "blah"
  agent.fetch()