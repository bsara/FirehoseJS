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

### 
# Test of login w un/pw occurs with every test
###

firehoseTest 'Test Immediate Login', 11, (agent) ->
  ok agent.firstName?
  ok agent.lastName?
  ok agent.email?
  agent.login()
  .done (data, textStatus) ->
    ok not textStatus?
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
    
firehoseTest 'Gravatar URL', 1, (agent) ->
  ok agent.gravatarURL().length > 40 
  start()
    
firehoseTest 'Status Code Handlers', 1, (agent) ->
  FirehoseJS.client.statusCodeHandlers =
    401: ->
      ok true
      start()
  FirehoseJS.client.APIAccessToken = "blah"
  agent.fetch()
  
firehoseTest 'Archive/Unarchive', 8, (agent) ->
  agent.archive()
  agent2 = FirehoseJS.Agent.agentWithID agent.id
  agent2.unarchive()
  ok agent.id == agent2.id
  ok agent.createdAt == agent2.createdAt
  ok agent.firstName == agent2.firstName
  ok agent.lastName == agent2.lastName
  ok agent.email == agent2.email
  ok agent.accessToken == agent2.accessToken
  ok agent.URLToken == agent2.URLToken
  ok agent.companies.length == agent2.companies.length
  start()
