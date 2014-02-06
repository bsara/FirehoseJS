module "Note"

firehoseTest 'Create', 2, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      note = Firehose.Note.noteWithBody( Faker.Lorem.words(5).join(" "), interaction )
      note.save()
      .done (data, textStatus) ->
        ok textStatus == "success"
        ok note.body?
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      note = Firehose.Note.noteWithBody( Faker.Lorem.words(5).join(" "), interaction )
      note.save()
      .done (data, textStatus) ->
        note.body = Faker.Lorem.words(50).join(" ")
        note.save()
        .done (data, textStatus) ->
          ok textStatus == "nocontent"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      note = Firehose.Note.noteWithBody( Faker.Lorem.words(5).join(" "), interaction )
      note.save()
      .done (data, textStatus) ->
        note.destroy()
        .done (data, textStatus) ->
          ok textStatus == "nocontent"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()