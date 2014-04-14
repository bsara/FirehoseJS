module "Company",
  teardown: ->
    window.unitTestDocumentURL = null

firehoseTest 'Create', 13, (agent) ->
  company = Firehose.Company.companyWithTitle( Faker.Lorem.words(1).join(" "), agent )
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
    ok company.isBrandNew == true
    ok company.tags?
    ok company.title?
    ok company.token?
    ok company.unresolvedCount == 0
    start()
  .fail ->
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
    ok company.isBrandNew?
    ok company.tags?
    ok company.title?
    ok company.token?
    ok company.unresolvedCount > 0
    start()
  .fail ->
    start()



firehoseTest 'Update', 17, (agent) ->
  company       = agent.companies[0]
  company.title = "Adam's Company"
  company.save()
  .done (saveData, saveTextStatus) ->
    equal saveTextStatus, "nocontent"
    company.fetch()
    .done (fetchData, fetchTextStatus) ->
      equal fetchTextStatus, "success"
      equal company.title, "Adam's Company"
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = Firehose.Company.companyWithTitle( Faker.Lorem.words(1).join(" "), agent )
  company.save()
  .done ->
    company.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Force Channels Fetch', 1, (agent) ->
  company = agent.companies[0]
  company.forceChannelsFetch()
  .done (data, textStatus) ->
    equal textStatus, "nocontent"
    start()
  .fail ->
    start()

firehoseTest 'Fetch Notifications', 2, (agent) ->
  company = agent.companies[0]
  notifications = company.notifications()
  notifications.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok notifications.length > 0
    start()
  .fail ->
    start()

firehoseTest 'Fetch Twitter Accounts', 2, (agent) ->
  company = agent.companies[0]
  twitterAccounts = company.twitterAccounts()
  twitterAccounts.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok twitterAccounts.length > 0
    start()
  .fail ->
    start()

firehoseTest 'Fetch Facebook Accounts', 2, (agent) ->
  company = agent.companies[0]
  facebookAccounts = company.facebookAccounts()
  facebookAccounts.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok facebookAccounts.length > 0
    start()
  .fail ->
    start()

firehoseTest 'Fetch Email Accounts', 2, (agent) ->
  company = agent.companies[0]
  emailAccounts = company.emailAccounts()
  emailAccounts.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok emailAccounts.length > 0
    start()
  .fail ->
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
              .fail ->
                start()
            .fail ->
              start()
          .fail ->
            start()
        .fail ->
          start()
      .fail ->
        start()
    .fail ->
      start()


