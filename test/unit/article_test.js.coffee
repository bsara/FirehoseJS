module "Article"


firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  article = Firehose.Article.articleWithTitleAndBody( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), product)
  article.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    start()
  .fail ->
    start()


firehoseTest 'Fetch', 5, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  article = Firehose.Article.articleWithTitleAndBody( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), product)
  article.save()
  .done ->
    article.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok article.id?
      ok article.title?
      ok article.body?
      ok article.createdAt?
      start()
    .fail ->
      start()
  .fail ->
    start()


firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  article = Firehose.Article.articleWithTitleAndBody( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), product)
  article.save()
  .done ->
    article.title = Faker.Lorem.words(10).join(" ")
    article.body  = Faker.Lorem.words(50).join(" ")
    article.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail ->
      start()
  .fail ->
    start()


firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  article = Firehose.Article.articleWithTitleAndBody( Faker.Lorem.words(4).join(" "), Faker.Lorem.words(10).join(" "), product)
  article.save()
  .done ->
    article.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail ->
      start()
  .fail ->
    start()