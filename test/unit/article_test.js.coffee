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

module "Article"

firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  article = FirehoseJS.Article.articleWithTitleBodyAndCompany( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), company)
  article.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch', 5, (agent) ->
  company = agent.companies[0]
  article = FirehoseJS.Article.articleWithTitleBodyAndCompany( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), company)
  article.save()
  .done (data, textStatus) ->
    article.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok article.id?
      ok article.title?
      ok article.body?
      ok article.createdAt?
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  article = FirehoseJS.Article.articleWithTitleBodyAndCompany( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), company)
  article.save()
  .done (data, textStatus) ->
    article.title = Faker.Lorem.words(10).join(" ")
    article.body  = Faker.Lorem.words(50).join(" ")
    article.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  article = FirehoseJS.Article.articleWithTitleBodyAndCompany( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), company)
  article.save()
  .done (data, textStatus) ->
    article.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()