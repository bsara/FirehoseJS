module "Product"

firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  product = Firehose.Product.productWithName( Faker.Lorem.words(1).join(""), company)
  product.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok product.id?
    ok product.token?
    ok product.name?
    ok company.createdAt?
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch', 13, (agent) ->
  company = agent.companies[0]
  company.fetch()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok company.id?
    ok company.name?
    ok company.token?
    ok company.createdAt?
    start()
  .fail ->
    start()

firehoseTest 'Fetch Based on KB subdomain', 3, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  product.fetch()
  .done ->
    kbProduct = Firehose.Product.productWithKBSubdomain product.knowledgeBaseSubdomain
    kbProduct.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok kbProduct.id?
      ok kbProduct.name?
      ok kbProduct.knowledgeBaseSubdomain?
      ok kbProduct.knowledgeBaseCustomDomain?
      ok kbProduct.knowledgeBaseCSS?
      ok kbProduct.knowledgeBaseLayoutTemplate?
      ok kbProduct.knowledgeBaseSearchTemplate?
      ok kbProduct.knowledgeBaseArticleTemplate?
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Fetch Based on KB custom domain', 3, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  product.fetch()
  .done ->
    kbProduct = Firehose.Product.productWithKBCustomDomain product.knowledgeBaseCustomDomain
    kbProduct.fetch()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok kbProduct.id?
      ok kbProduct.name?
      ok kbProduct.knowledgeBaseSubdomain?
      ok kbProduct.knowledgeBaseCustomDomain?
      ok kbProduct.knowledgeBaseCSS?
      ok kbProduct.knowledgeBaseLayoutTemplate?
      ok kbProduct.knowledgeBaseSearchTemplate?
      ok kbProduct.knowledgeBaseArticleTemplate?
      start()
    .fail ->
      start()
  .fail ->
    start()

firehoseTest 'Fetch (throws error because not enough info is set)', 1, (agent) ->
  company = agent.companies[0]
  product = company.products[0]
  product.fetch()
  .done ->
    kbProduct = Firehose.Product.productWithKBCustomDomain product.knowledgeBaseCustomDomain
    throws kbProduct.fetch()
    start()
  .fail ->
    start()

firehoseTest 'Fetch (include extra settings)', 16, (agent) ->
  company = agent.companies[0]
  company.fetch( include: ["kb", "chat"] )
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok company.title?
    ok company.knowledgeBaseSubdomain?
    ok company.knowledgeBaseCustomDomain?
    ok company.knowledgeBaseCSS?
    ok company.knowledgeBaseLayoutTemplate?
    ok company.knowledgeBaseSearchTemplate?
    ok company.knowledgeBaseArticleTemplate?
    ok company.chatTitleTextColor?         
    ok company.chatTitleBackgroundColor?   
    ok company.chatAgentColor?             
    ok company.chatCustomerColor?          
    ok company.chatFieldTextColor?         
    ok company.chatFieldBackgroundColor?   
    ok company.chatBackgroundColor?        
    ok company.chatResponseBackgroundColor?
    start()
  .fail ->
    start()

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  product = Firehose.Product.productWithName( Faker.Lorem.words(1).join(""), company)
  product.save()
  .done (data, textStatus) ->
    product.name = Faker.Lorem.words(1).join("")
    product.save()
    .done (data, textStatus) ->
      product2 = Firehose.Product.productWithID product.id, company
      product2.fetch()
      .done (data, textStatus) -> 
        equal textStatus, "nocontent"
        ok product2.id?
        ok product2.token?
        ok product2.name?
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  product = Firehose.Product.productWithName( Faker.Lorem.words(1).join(" "), company)
  product.save()
  .done (data, textStatus) ->
    product.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    

firehoseTest 'Fetch Articles', 2, (agent) ->
  company  = agent.companies[0]
  product  = company.products[0]
  articles = product.articles()
  articles.next()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok articles.length > 0
    start()
  .fail ->
    start()

firehoseTest 'Search Articles', 2, (agent) ->
  company  = agent.companies[0]
  product  = company.products[0]
  articles = product.articles()
  articles.next()
  .done ->
    firstWord = articles[0].body.split(" ")[0]
    searchedArticles = product.searchedArticles firstWord
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
  company  = agent.companies[0]
  product  = company.products[0]
  articles = product.articles()
  articles.next()
  .done ->
    firstWord = articles[0].body.split(" ")[0]
    searchedArticles = product.searchedArticles firstWord
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

firehoseTest 'Produce URL for products kb', 5, (agent) ->
  company      = agent.companies[0]
  product      = company.products[0]
  subdomain    = product.get('knowledgeBaseSubdomain')
  customDomain = product.get('knowledgeBaseCustomDomain')

  window.unitTestDocumentURL = "http://localhost:4001"
  ok product.kbBaseURL() == "http://#{subdomain}.lvh.me:4007"

  window.unitTestDocumentURL = "http://localhost:4201"
  ok product.kbBaseURL() == "http://#{subdomain}.lvh.me:4207"

  window.unitTestDocumentURL = "https://beta.firehoseapp.com"
  ok product.kbBaseURL() == "http://#{subdomain}.firehosesupport.com"

  window.unitTestDocumentURL = "https://www.firehoseapp.com"
  ok product.kbBaseURL() == "http://#{customDomain}"

  product.set('knowledgeBaseCustomDomain', null)
  window.unitTestDocumentURL = "https://www.firehoseapp.com"
  ok product.kbBaseURL() == "http://#{subdomain}.firehosehelp.com"

  start()