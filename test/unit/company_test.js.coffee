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

module "Company"

firehoseTest 'Create', 13, (agent) ->
  company = new FirehoseJS.Company( Faker.Lorem.words(1).join(" "), agent )
  company.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok company.agentInvites?
    ok company.agents.length == 1
    ok company.cannedResponses?
    ok company.createdAt?
    ok company.fetchAutomatically
    ok company.forwardingEmailAddress?
    ok company.id?
    ok company.numberOfAccounts == 1    
    ok company.tags?
    ok company.title?
    ok company.token?
    ok company.unresolvedCount == 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Fetch', 13, (agent) ->
  company = agent.companies[0]
  company.fetch()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok company.agentInvites.length > 0
    ok company.agents.length > 0
    ok company.cannedResponses?
    ok company.createdAt?
    ok company.fetchAutomatically
    ok company.forwardingEmailAddress?
    ok company.id?
    ok company.numberOfAccounts > 0    
    ok company.tags?
    ok company.title?
    ok company.token?
    ok company.unresolvedCount > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Update', 3, (agent) ->
  company = agent.companies[0]
  company.title = "Adam's Company"
  company.save()
  .done (data, textStatus) ->
    equal textStatus, "nocontent"
    fetchedCompany = new FirehoseJS.Company( company.id )
    fetchedCompany.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      equal fetchedCompany.title, "Adam's Company"
      start()
    .fail ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Destroy', 1, (agent) ->
  company = new FirehoseJS.Company( Faker.Lorem.words(1).join(" "), agent )
  company.save()
  .done (data, textStatus) ->
    company.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Force Channels Fetch', 1, (agent) ->
  company = agent.companies[0]
  company.forceChannelsFetch()
  .done (data, textStatus) ->
    equal textStatus, "nocontent"
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch Notifications', 2, (agent) ->
  company = agent.companies[0]
  notifications = company.notifications()
  notifications.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok notifications.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch Twitter Accounts', 2, (agent) ->
  company = agent.companies[0]
  twitterAccounts = company.twitterAccounts()
  twitterAccounts.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok twitterAccounts.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Fetch Facebook Accounts', 2, (agent) ->
  company = agent.companies[0]
  facebookAccounts = company.facebookAccounts()
  facebookAccounts.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok facebookAccounts.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Fetch Email Accounts', 2, (agent) ->
  company = agent.companies[0]
  emailAccounts = company.emailAccounts()
  emailAccounts.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok emailAccounts.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Add and Remove Agent', 2, (agent) ->
  company = agent.companies[0]
  window.nextTestAgent (addAgent) ->
    # log in the agent that owns the company
    agent.login()
    .done ->
      # fetch the company
      company.fetch()
      .done ->
        # get current agent count
        count = company.agents.length
        # add agent  
        company.addAgent(addAgent)
        .done ->
          # fetch company
          company.fetch()
          .done ->
            # verify agent was added
            ok company.agents.length == count + 1
            # remove agent
            company.removeAgent(addAgent)
            .done ->
              # fetch company
              company.fetch()
              .done ->
                # verify agent was removed
                ok company.agents.length == count
                start()
              .fail (jqXHR, textStatus, errorThrown) ->
                start()
            .fail (jqXHR, textStatus, errorThrown) ->
              start()
          .fail (jqXHR, textStatus, errorThrown) ->
            start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  
  
