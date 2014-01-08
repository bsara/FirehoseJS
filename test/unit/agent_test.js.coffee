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
  agent = new FirehoseJS.Agent(Faker.Internet.email(), Faker.Name.firstName())
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
       
firehoseTest 'Log In', 8, (agent) ->
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