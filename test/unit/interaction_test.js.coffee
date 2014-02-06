module "Interaction"

firehoseTest 'Index', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria()
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      ok interactions.length > 0     
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Reply To Twitter', 1, (agent) ->
  window.realTestAgent (realAgent) ->
    company = realAgent.companies[0]
    customers = company.customersWithCriteria( channels: ["twitter"] )
    customers.next()
    .done (data, textStatus) ->
      customer = customers[0]
      interactions = customer.interactions()
      interactions.next()
      .done (data, textStatus) ->
        interaction = interactions[0]
        interaction.responseDraft = Faker.Lorem.words(10).join(" ")
        interaction.reply()
        .done (data, textStatus) ->
          ok textStatus == "success"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
      
firehoseTest 'Reply To Facebook', 1, (agent) ->
  window.realTestAgent (realAgent) ->
    company = realAgent.companies[0]
    customers = company.customersWithCriteria( channels: ["facebook"] )
    customers.next()
    .done (data, textStatus) ->
      customer = customers[0]
      interactions = customer.interactions()
      interactions.next()
      .done (data, textStatus) ->
        interaction = interactions[0]
        interaction.responseDraft = Faker.Lorem.words(10).join(" ")
        interaction.reply()
        .done (data, textStatus) ->
          ok textStatus == "success"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
      
firehoseTest 'Reply To Email', 1, (agent) ->
  window.realTestAgent (realAgent) ->
    company = realAgent.companies[0]
    customers = company.customersWithCriteria( channels: ["email"] )
    customers.next()
    .done (data, textStatus) ->
      customer = customers[0]
      interactions = customer.interactions()
      interactions.next()
      .done (data, textStatus) ->
        interaction = interactions[0]
        interaction.responseDraft = Faker.Lorem.words(10).join(" ")
        interaction.reply()
        .done (data, textStatus) ->
          ok textStatus == "success"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()

firehoseTest 'Attachments', 4, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    tested = false
    for customer in customers
      return if tested
      interactions = customer.interactions()
      interactions.next()
      .done (data, textStatus) ->
        for interaction in interactions
          return if tested
          for attachment in interaction.attachments          
            ok attachment.id?            
            ok attachment.filename?
            ok attachment.temporaryURL?
            ok attachment.createdAt?
            start()
            tested = true
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch With Token', 9, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      interactionWithToken = Firehose.Interaction.interactionWithToken interaction.token
      interaction.fetch()
      .done (data, textStatus) ->
        ok textStatus == "success"
        ok interaction.id?
        ok interaction.body?
        ok interaction.channel?
        ok interaction.receivedAt?
        ok interaction.createdAt?
        ok interaction.customerAccount?
        ok interaction.customerAccount.id?
        ok interaction.customerAccount.createdAt?
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch With ID', 9, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      interactionWithToken = Firehose.Interaction.interactionWithToken interaction.token
      interaction.fetch()
      .done (data, textStatus) ->
        ok textStatus == "success"
        ok interaction.id?
        ok interaction.body?
        ok interaction.channel?
        ok interaction.receivedAt?
        ok interaction.createdAt?
        ok interaction.customerAccount?
        ok interaction.customerAccount.id?
        ok interaction.customerAccount.createdAt?
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
  
firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      interaction.responseDraft = Faker.Lorem.words(10).join(" ")
      interaction.resolved = !interaction.resolved
      interaction.save()
      .done (data, textStatus) ->
        ok textStatus == "nocontent"
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      interaction.destroy()
      .done (data, textStatus) ->
        ok textStatus == "nocontent"
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Add And Remove Interaction Tag', 4, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["email"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      tagCount = interaction.tags.length
      tag = Firehose.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
      tag.save()
      .done (data, textStatus) ->
        interaction.addTag( tag )  
        .done (data, textStatus) ->
          ok textStatus == "nocontent"
          ok interaction.tags.length > tagCount
          interaction.removeTag( tag )
          .done (data, textStatus) ->
            ok textStatus == "nocontent"
            ok interaction.tags.length == tagCount
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
    
firehoseTest 'Add and Remove Flagged Agent', 4, (agent) ->
  company = agent.companies[0]
  window.nextTestAgent (addAgent) ->
    # log in the agent that owns the company
    agent.login()
    .done ->
      # fetch the company
      company.fetch()
      .done ->
        customers = company.customersWithCriteria( channels: ["email"] )
        customers.next()
        .done (data, textStatus) ->
          customer = customers[0]
          interactions = customer.interactions()
          interactions.next()
          .done (data, textStatus) ->
            interaction = interactions[0]
            flaggedAgentsCount = interaction.flaggedAgents.length
            interaction.flagAgent( agent ) 
            .done (data, textStatus) ->
              ok textStatus == "nocontent"
              ok interaction.flaggedAgents.length > flaggedAgentsCount
              interaction.unflagAgent( agent) 
              .done (data, textStatus) ->
                ok textStatus == "nocontent"
                ok interaction.flaggedAgents.length == flaggedAgentsCount
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
