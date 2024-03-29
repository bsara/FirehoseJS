module "Customer"

firehoseTest 'Create Customer From JSON', 2, (agent) ->
  company = agent.companies[0]
  customerJSON = `{"created_at":"2012-01-26T01:02:01Z","id":26,"location":null,"raw_name":"Adam Kirk","time_zone":null,"name":"Adam Kirk","newest_interaction_id":536509,"newest_interaction_excerpt":"ignore, testing pusher\n\n--\nAdam Kirk\nSent with Airmail\n","newest_interaction_received_at":"2014-03-01T16:44:23Z","interaction_flagged_agents":[],"customer_accounts":[{"channel":"email","created_at":"2012-01-26T01:02:01Z","description":null,"followers_count":0,"following_us":false,"id":26,"image_url":null,"username":"atomkirk@gmail.com"}]}`
  customer = Firehose.Customer.customerWithJSON customerJSON
  ok customer.id = 26
  ok customer.newestInteractionId == 536509
  start()

firehoseTest 'List', 2, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch', 8, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]    
    customer.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok customer.id?
      ok customer.name?
      ok customer.location?
      ok customer.timeZone?
      ok customer.createdAt?
      ok customer.customerAccounts.length > 0
      ok customer.customerFlaggedAgents.length > 0
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]    
    customer.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Resolve All Interactions', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]    
    customer.resolveAllInteractions()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'List Unresolved', 2, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( everything: true )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'List Paginated', 2, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria()
  customers.perPage = 2
  customers.page    = 2
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'List Newest First', 3, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria( sort: "newest_first" )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    first = customers[0]
    last = customers[customers.length - 1]
    ok first.newestInteractionReceivedAt > last.newestInteractionReceivedAt
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'List Newest First', 3, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria( sort: "oldest_first" )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    first = customers[0]
    last = customers[customers.length - 1]
    ok first.newestInteractionReceivedAt < last.newestInteractionReceivedAt
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'List Email Only', 3, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    allEmail = true
    for customer in customers
      customerAccount = customer.customerAccounts[0]
      if customerAccount.channel != "email"
        allEmail = false
        break
    ok allEmail
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
        
firehoseTest 'List Facebook Only', 3, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria( channels: ["facebook"] )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    allEmail = true
    for customer in customers
      customerAccount = customer.customerAccounts[0]
      if customerAccount.channel != "facebook"
        allEmail = false
        break
    ok allEmail
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
        
firehoseTest 'List Twitter Only', 3, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    allEmail = true
    for customer in customers
      customerAccount = customer.customerAccounts[0]
      if customerAccount.channel != "twitter"
        allEmail = false
        break
    ok allEmail
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'List Matched Keywords', 2, (agent) ->
  company           = agent.companies[0]
  customers         = company.customersWithCriteria( searchString: "a" )
  customers.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok customers.length > 0
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Agent Has Dibs', 1, (agent) ->
  company   = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    # fetch customer interactions (calling dibs on the customer)
    interactions.next()
    .done (data, textStatus) ->
      customers = company.customersWithCriteria()
      customers.next()
      .done (data, textStatus) ->
        anyCustomerHasAnAgentWithDibs = false
        for c in customers
          if c.agentWithDibs?
            anyCustomerHasAnAgentWithDibs = true
        ok anyCustomerHasAnAgentWithDibs
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Avatar URL', 2, (agent) ->
  company   = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    customerAccount = customer.customerAccounts[0]
    ok customerAccount.avatarURL().length > 40
    delete customerAccount.imageURL
    ok customerAccount.avatarURL().length > 40
    start()

