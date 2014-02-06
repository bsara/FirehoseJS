module "Canned Response"

firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  cannedResponse = Firehose.CannedResponse.cannedResponseWithNameAndText( Faker.Lorem.words(1).join(" "), Faker.Lorem.words(10).join(" "), company)
  cannedResponse.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  cannedResponse = Firehose.CannedResponse.cannedResponseWithNameAndText( Faker.Lorem.words(1).join(" "), Faker.Lorem.words(10).join(" "), company)
  cannedResponse.save()
  .done (data, textStatus) ->
    cannedResponse.text = Faker.Lorem.words(50).join(" ")
    cannedResponse.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  cannedResponse = Firehose.CannedResponse.cannedResponseWithNameAndText( Faker.Lorem.words(1).join(" "), Faker.Lorem.words(10).join(" "), company)
  cannedResponse.save()
  .done (data, textStatus) ->
    cannedResponse.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()