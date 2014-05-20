module "Agent"

asyncTest 'Sign Up', 11, ->
  agent = Firehose.Agent.agentWithEmailAndPassword(Faker.Internet.email(), Faker.Name.firstName())
  agent.signUpWithFirstAndLastName( Faker.Name.firstName(), Faker.Name.lastName() )
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.avatarURL?
    ok agent.id?
    ok agent.createdAt?
    ok agent.DNDIsManuallyTurnedOn?
    ok agent.digestDays?
    equal agent.companies.length, 1
    ok agent.currentCompany?
    start()
  .fail ->
    start()

asyncTest 'Sign Up (Fail with errors populated)', 3, ->
  agent = Firehose.Agent.agentWithEmailAndPassword(Faker.Internet.email(), "")
  agent.signUpWithFirstAndLastName( "", Faker.Name.lastName() )
  .done ->
    start()
  .fail ->
    ok agent.errors[0] == "Password digest can't be blank"
    ok agent.errors[1] == "First name can't be blank"
    ok agent.HTMLErrorString() == "<ul><li>Password digest can't be blank</li><li>First name can't be blank</li></ul>"
    start()

###
# Test of login w un/pw occurs with every test
###

firehoseTest 'Test Immediate Login', 16, (agent) ->
  ok agent.firstName?
  ok agent.lastName?
  ok agent.email?
  agent.login()
  .done (data, textStatus) ->
    ok not textStatus?
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.avatarURL?
    ok agent.id?
    ok agent.createdAt?
    ok agent.DNDStartHourUTC?
    ok agent.DNDEndHourUTC?
    ok agent.DNDIsManuallyTurnedOn?
    ok agent.digestDays?
    equal agent.companies.length, 1
    ok agent.currentCompany?
    start()
  .fail ->
    start()

firehoseTest 'Log In With Access Token', 13, (agent) ->
  agent.email = null
  agent.login()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.avatarURL?
    ok agent.id?
    ok agent.createdAt?
    ok agent.DNDStartHourUTC?
    ok agent.DNDEndHourUTC?
    ok agent.DNDIsManuallyTurnedOn?
    ok agent.digestDays?
    equal agent.companies.length, 1
    ok agent.currentCompany?
    start()
  .fail ->
    start()

firehoseTest 'Log Out', 2, (agent) ->
  agent.email = null
  agent.logout()
  .done (data, textStatus) ->
    equal textStatus, "nocontent"
    agent.fetch()
    .done ->
      start()
    .fail (jqXHR) ->
      equal jqXHR.status, 401
      start()
  .fail ->
    start()

firehoseTest 'Fetch', 19, (agent) ->
  agent.fetch()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok agent.firstName?
    ok agent.lastName?
    ok agent.email?
    ok agent.avatarURL?
    ok agent.id?
    ok agent.createdAt?
    ok agent.DNDStartHourUTC?
    ok agent.DNDEndHourUTC?
    ok agent.DNDIsManuallyTurnedOn?
    ok agent.digestDays?
    equal agent.companies.length, 1
    company = agent.currentCompany
    ok company?
    ok company.id?
    ok company.title?
    ok company.token?
    ok company.fetchAutomatically
    ok company.isBrandNew == false
    ok company.createdAt?
    start()
  .fail ->
    start()

firehoseTest 'Update', 12, (agent) ->
  agent.firstName               = "Heidi"
  agent.lastName                = "Kirk"
  agent.DNDStartHourUTC         = 10
  agent.DNDEndHourUTC           = 16
  agent.DNDIsManuallyTurnedOn   = true
  agent.digestDays              = [1,2]
  agent.setNewPassword Faker.Lorem.words(1)
  agent.save()
  .done (saveData, saveTextStatus) ->
    equal saveTextStatus, "nocontent"
    agent.fetch()
    .done (fetchData, fetchTextStatus) ->
      equal fetchTextStatus, "success"
      equal agent.firstName, "Heidi"
      equal agent.lastName, "Kirk"
      equal agent.DNDStartHourUTC, 10
      equal agent.DNDEndHourUTC, 16
      equal agent.DNDIsManuallyTurnedOn, true
      equal agent.digestDays[0], 1
      equal agent.digestDays[1], 2
      ok agent.email?
      ok agent.avatarURL?
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
  Firehose.client.statusCodeHandlers =
    401: ->
      ok true
      start()
  Firehose.client.APIAccessToken = "blah"
  agent.fetch()
  .done ->
    start()

firehoseTest 'Archive/Unarchive', 8, (agent) ->
  agent.archive()
  agent2 = Firehose.Agent.agentWithID agent.id
  agent2.unarchive()

  equal agent.id, agent2.id
  equal agent.createdAt, agent2.createdAt
  equal agent.firstName, agent2.firstName
  equal agent.lastName, agent2.lastName
  equal agent.email, agent2.email
  equal agent.avatarURL, agent2.avatarURL
  equal agent.accessToken, agent2.accessToken
  equal agent.URLToken, agent2.URLToken
  equal agent.companies.length, agent2.companies.length

  start()
