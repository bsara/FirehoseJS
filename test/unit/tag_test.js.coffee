module "Tag"

firehoseTest 'Create', 4, (agent) ->
  company = agent.companies[0]
  tag = Firehose.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
  tag.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok tag.id?
    ok tag.label?
    ok tag.createdAt?
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  tag = Firehose.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
  tag.save()
  .done (data, textStatus) ->
    tag.label = Faker.Lorem.words(1).join(" ")
    tag.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  tag = Firehose.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
  tag.save()
  .done (data, textStatus) ->
    tag.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()