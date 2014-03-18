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
    ok company.numberOfAccounts == 1    
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
    ok company.numberOfAccounts > 0    
    ok company.tags?
    ok company.title?
    ok company.token?
    ok company.unresolvedCount > 0
    start()
  .fail ->
    start()

firehoseTest 'Fetch Based on KB subdomain', 3, (agent) ->
  company = agent.companies[0]
  company.fetch()
  .done ->
    kbCompany = Firehose.Company.companyWithKBSubdomain company.knowledgeBaseSubdomain
    kbCompany.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok company.id?
      ok company.title?
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Fetch Based on KB custom domain', 3, (agent) ->
  blah = this
  company = agent.companies[0]
  company.fetch()
  .done ->
    kbCompany = Firehose.Company.companyWithKBCustomDomain company.knowledgeBaseCustomDomain
    kbCompany.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok company.id?
      ok company.title?
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Fetch (throws error because not enough info is set)', 1, (agent) ->
  company = agent.companies[0]
  company.fetch()
  .done ->
    kbCompany = Firehose.Company.companyWithKBCustomDomain company.knowledgeBaseCustomDomain
    throws kbCompany.fetch()
    start()
  .fail ->
    start()

firehoseTest 'Fetch (include extra settings)', 8, (agent) ->
  company = agent.companies[0]
  company.fetch( include_settings: ["kb_theming"] )
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok company.title?
    ok company.knowledgeBaseSubdomain?
    ok company.knowledgeBaseCustomDomain?
    ok company.knowledgeBaseCSS?
    ok company.knowledgeBaseLayoutTemplate?
    ok company.knowledgeBaseSearchTemplate?
    ok company.knowledgeBaseArticleTemplate?
    start()
  .fail ->
    start()


firehoseTest 'Update', 9, (agent) ->
  company       = agent.companies[0]
  company.title = "Adam's Company"
  company.knowledgeBaseSubdomain       = "mystrou"
  company.knowledgeBaseCustomDomain    = "support.firehoseapp.com"
  company.knowledgeBaseCSS             = "css"
  company.knowledgeBaseLayoutTemplate  = "layout template"
  company.knowledgeBaseSearchTemplate  = "search template"
  company.knowledgeBaseArticleTemplate = "article template"
  company.save()
  .done (saveData, saveTextStatus) ->
    equal saveTextStatus, "nocontent"
    company.fetch()
    .done (fetchData, fetchTextStatus) ->
      equal fetchTextStatus, "success"
      equal company.title, "Adam's Company"
      equal company.knowledgeBaseSubdomain, "mystrou"
      equal company.knowledgeBaseCustomDomain, "support.firehoseapp.com"
      equal company.knowledgeBaseCSS, "css"
      equal company.knowledgeBaseLayoutTemplate, "layout template"
      equal company.knowledgeBaseSearchTemplate, "search template"
      equal company.knowledgeBaseArticleTemplate, "article template"
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

firehoseTest 'Fetch Articles', 2, (agent) ->
  company = agent.companies[0]
  articles = company.articles()
  articles.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok articles.length > 0
    start()
  .fail ->
    start()

firehoseTest 'Search Articles', 2, (agent) ->
  company = agent.companies[0]
  articles = company.articles()
  articles.next()
  .done ->
    firstWord = articles[0].body.split(" ")[0]
    searchedArticles = company.searchedArticles firstWord
    searchedArticles.next()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok searchedArticles.length > 0
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Search Articles (Abort)', 1, (agent) ->
  company = agent.companies[0]
  articles = company.articles()
  articles.next()
  .done ->
    firstWord = articles[0].body.split(" ")[0]
    searchedArticles = company.searchedArticles firstWord
    searchedArticles.next()
    .done ->
      throw "shouldn't have gotten here"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      ok textStatus == 'abort'
      start()
    searchedArticles.abort()
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

firehoseTest 'Produce URL for companys kb', 5, (agent) ->
  company      = agent.companies[0]
  subdomain    = company.get('knowledgeBaseSubdomain')
  customDomain = company.get('knowledgeBaseCustomDomain')

  window.unitTestDocumentURL = "http://localhost:4001"
  ok company.kbBaseURL() == "http://#{subdomain}.lvh.me:4007"

  window.unitTestDocumentURL = "http://localhost:4201"
  ok company.kbBaseURL() == "http://#{subdomain}.lvh.me:4207"

  window.unitTestDocumentURL = "https://beta.firehoseapp.com"
  ok company.kbBaseURL() == "http://#{subdomain}.firehosesupport.com"

  window.unitTestDocumentURL = "https://www.firehoseapp.com"
  ok company.kbBaseURL() == "http://#{customDomain}"

  company.set('knowledgeBaseCustomDomain', null)
  window.unitTestDocumentURL = "https://www.firehoseapp.com"
  ok company.kbBaseURL() == "http://#{subdomain}.firehosehelp.com"

  start()
